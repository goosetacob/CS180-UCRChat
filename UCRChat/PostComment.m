//
//  UIViewController+PostComment.m
//  UCRChat
//
//  Created by user24887 on 11/29/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "PostComment.h"
#import "AddPostController.h"
#import "AddMultiPost.h"

@implementation PostComment

CustomCell *cell;

- (id)initWithCoder: (NSCoder *) aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        CPostArray = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) viewWillAppear: (BOOL) animated {
    [self PullData];
    [self.Comment_Table reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [CPostArray removeAllObjects];
    self.Comment_Table.dataSource = self;
    self.Comment_Table.delegate = self;self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.Comment_Table setBackgroundColor: [UIColor clearColor]];
    [self.Comment_Table setOpaque: NO];
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.349 blue:0.596 alpha:0.5]];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(PullData) forControlEvents:UIControlEventValueChanged];
    
   // [self PullData];
    
    [self.Comment_Table addSubview:_refreshControl];
    [self.Comment_Table reloadData];
}

- (void) PullData
{
    NSMutableArray* CommentIDs = [self.CurrentObject objectForKey:@"Comments"];
    NSLog(@"Array: %@", CommentIDs);
    
    bool foundItem = false;
    for(NSString* i in CommentIDs)
    {
        NSLog(@"I: %@", i);
        foundItem = false;
        for(PFObject* item in CPostArray)
        {
            if([item.objectId isEqualToString:i]){
                foundItem = true;
                break;
            }
        }
        if(foundItem == false){
            PFQuery *query = [PFQuery queryWithClassName:@"PostCommentObject"];
            [query getObjectInBackgroundWithId:i block:^(PFObject *Comment, NSError *error) {
                [CPostArray addObject:Comment];
            }];
        }
    }
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"createdAt"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [CPostArray
                                 sortedArrayUsingDescriptors:sortDescriptors];
    CPostArray = [[NSMutableArray alloc] initWithArray:sortedEventArray];

    [self.Comment_Table reloadData];
    [_refreshControl endRefreshing];
}

- (IBAction)backbtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // NSLog(@"%lu", (unsigned long)PostArray.count);
    return CPostArray.count;
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.Comment_Table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.Comment_Table setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Divider_line@2x.png"]]];
    CGFloat cellcolor = 1.0 - (CGFloat)indexPath.row / 20.0;
    
    cell.ColorView.backgroundColor = [UIColor colorWithWhite:cellcolor alpha:1.0];
    
    PFObject* CurrentObject = [CPostArray objectAtIndex:indexPath.row];
    
    NSString* CellIdentifier = nil;
    NSNumber* TextBool = CurrentObject[@"Text"];
    NSNumber* ImageBool = CurrentObject[@"Photo"];
    bool Text =  [TextBool boolValue];
    bool Photo =  [ImageBool boolValue];
    
    if(Text) CellIdentifier = @"CommentSegue";
    else if(Photo) CellIdentifier = @"CommentPhotoSegue";
    //else CellIdentifier = @"CommentSegue";
    
    cell = [tableView
            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    //Goin to obtain commenter's proile Picture
    PFFile* PICTURE = [CurrentObject objectForKey:@"ProfilePicture"];
    NSURL* imageURL = [[NSURL alloc] initWithString:PICTURE.url];
    NSData* idata = [NSData dataWithContentsOfURL:imageURL];
    cell.Commenter_Profile_Picture.image = [UIImage imageWithData:idata];
    //Going to obtain the User's Name
    cell.Commenter_Name.text = [CurrentObject objectForKey:@"Name"];
    
   
    if([CellIdentifier isEqualToString:@"CommentSegue"])
        cell.Commenter_TextPost.text = [CurrentObject objectForKey:@"TextComment"];
    else{
        PICTURE = [CurrentObject objectForKey:@"ImageComment"];
        imageURL = [[NSURL alloc] initWithString:PICTURE.url];
        idata = [NSData dataWithContentsOfURL:imageURL];

        cell.Commenter_PhotoPost.image = [UIImage imageWithData:idata];
    }
    
    return cell;
}

//sending the seugue nformatoion to the view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"CommentPost"])
    {
        //Creating the controller vieww where i will send the information
        AddPostController *PostController = segue.destinationViewController;
        PostController.Identifier = @"CommentPost";
        PostController.UserID = self.CommentID;
        PostController.CurrentUserImage = self.CurrentUserImage;
        PostController.CurrentUserNAME = self.CurrentUserNAME;
        PostController.CurrentObject = self.CurrentObject;
    }
    if ([[segue identifier] isEqualToString:@"MultimediaComment"])
    {
        AddMultiPost* PostController = segue.destinationViewController;
        PostController.Identifier = @"MultimediaComment";
        PostController.UserID = self.CommentID;
        PostController.CurrentUserImage = self.CurrentUserImage;
        PostController.CurrentUserNAME = self.CurrentUserNAME;
        PostController.CurrentObject = self.CurrentObject;
    }
}

- (void)dealloc {
    [_Comment_Table release];
    [super dealloc];
}
@end
