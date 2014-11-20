//
//  TimelineController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "TimelineController.h"
#import "CustomCell.h"
#import "PostViewController.h"

@interface TimelineController ()

@end

@implementation TimelineController
@synthesize PostTable;
;
static int numLikes = 0;
static NSUInteger numComments = 0;
//static bool result = 0;

PFObject *tempObject;
CustomCell *cell;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.PostTable setBackgroundColor: [UIColor clearColor]];
    [self.PostTable setOpaque: NO];
    self.PostTable.dataSource = self;
    self.PostTable.delegate = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(retrieveFromParse) forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retrieveFromParse) userInfo:nil repeats:YES];
    
    
    [self.PostTable addSubview:_refreshControl];
    [self.PostTable reloadData];
    
    [self retrieveFromParse ];
    
    
}

- (void) retrieveFromParse
{
    PFQuery *retrievePosts = [PFQuery queryWithClassName:@"GlobalTimeline"];
    [retrievePosts orderByDescending:@"createdAt"];
    [retrievePosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(!error)
        {
            PostArray = [[NSMutableArray alloc ] initWithArray:objects];
            [self.PostTable reloadData];
            [_refreshControl endRefreshing];
        }

    }];
    
    PFQuery *retrieve = [PFQuery queryWithClassName:@"_User"];
    [retrieve findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             userarray = [[NSArray alloc ] initWithArray:objects];
         }
     }];
    
}



//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"%lu", (unsigned long)PostArray.count);
    return PostArray.count;
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //setup cell
    tempObject = [PostArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"mycell";
    
    cell = [tableView
            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    //loading indicator
    //[self.view addSubview: cell.LoadingPicture];
    //[cell.LoadingPicture startAnimating];
    
    cell.Likebtn.tag = indexPath.row;
    cell.CommentBtn.tag = indexPath.row;
    cell.Delete.tag = indexPath.row;
    [[cell Likebtn] addTarget:self action:@selector(LikeBTNUP:) forControlEvents:UIControlEventTouchUpInside];
    [[cell CommentBtn] addTarget:self action:@selector(commentBTNUP:) forControlEvents:UIControlEventTouchUpInside];
    [[cell Delete] addTarget:self action:@selector(DeleteBTN:) forControlEvents:UIControlEventTouchUpInside];
    cell.NAME.text = [tempObject objectForKey:@"User"];

    //To obtain the full name from the user on this cell
    NSString* User = [tempObject objectForKey:@"User"];
    bool picfound = false;
    PFFile* PICTURE = nil;
    for(PFObject* item in userarray)
    {
        if([[item objectForKey:@"username"] isEqualToString:User])
        {
            cell.NAME.text = item[@"fullName"];
            PICTURE = [item objectForKey:@"picture"];
            if(PICTURE)
            {
                [PICTURE getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *thumbnailImage = [UIImage imageWithData:data];
                    [cell.IMG setImage:thumbnailImage];
                }];
            }
            
            else cell.IMG.image = [UIImage imageNamed:@"Default Profile.jpg"];
            break;
        }
    }
    
    cell.POST.text = [tempObject objectForKey:@"Post"];
    numLikes = [[tempObject objectForKey:@"Likes"] intValue];
    cell.LikeText.text = [NSString stringWithFormat:@"%d", numLikes ];
    NSArray* array = [tempObject objectForKey:@"Comments"];
    numComments = array.count;
    cell.CommentBox.text = [NSString stringWithFormat:@"%ld", numComments ];
    
    //Check if we already lked the post to change the button text
    NSArray* temp_array = [tempObject objectForKey:@"LikesID"];
    for (NSString* Item in temp_array) {
        if([[PFUser currentUser].username isEqualToString:Item])
            [cell.Likebtn setTitle:@"Liked" forState:UIControlStateNormal];
    }

    
    return cell;
}

- (IBAction)LikeBTNUP:(id)sender {
    
    UIButton *LikeButton = (UIButton * )sender;
    PFObject *tmp = [PostArray objectAtIndex:LikeButton.tag];
    
    NSMutableArray* tmp_Array = [tmp objectForKey:@"LikesID"] ;
    bool found = false;

    for(id item in tmp_Array)
    {
        if([item isEqualToString:[PFUser currentUser].username])
            found = true;
    }
    
    if(found == false)
    {
        //Like Feauture
        [tmp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(!error)
             {
                 
                 [tmp incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:1]];
                 [tmp addUniqueObject:[PFUser currentUser].username forKey:@"LikesID"];
                 [tmp saveInBackground];
                 [LikeButton setTitle:@"Liked" forState:UIControlStateNormal];
                    [self.PostTable reloadData];
             cell.LikeText.text = [NSString stringWithFormat:@"%d", [[tmp objectForKey:@"Likes"] intValue]];
             }
         }];
    }
    //Dislike Feauture
    else
    {
        [tmp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if(!error)
            {
              [tmp incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:-1]];
              //Obtain array of LIKESId
                for(id item in tmp_Array)
                {
                    if([item isEqualToString:[PFUser currentUser].username]){
                        [tmp_Array removeObject: item];
                        [tmp saveInBackground];
                        [LikeButton setTitle:@"Like" forState:UIControlStateNormal];
                        [self.PostTable reloadData];

                    }
                }
                
            }
        }];
    }
}


- (IBAction)commentBTNUP:(id)sender {
   [self performSegueWithIdentifier:@"MySegue" sender:sender];
}

- (IBAction)AddButton:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"MySegue"]){
        
        //if you need to pass data to the next controller do it here
        UIButton *CommentButton = (UIButton * )sender;
        PFObject *tmp = [PostArray objectAtIndex:CommentButton.tag];
        PostViewController *SecondController = segue.destinationViewController;
        
        //To obtain the full name from the user on this cell
        NSString* User = [tmp objectForKey:@"User"];
        PFFile* ProfilePIC = nil;
        
        for(PFObject* item in userarray)
        {
            if([[item objectForKey:@"username"] isEqualToString:User]){
                SecondController.PARENT_NAME = item[@"fullName"];
                 ProfilePIC = item[@"picture"];
            }
        }
        
        SecondController.UserObject = tmp;
        SecondController.PARENT_POST = [tmp objectForKey:@"Post"];
        
        if(ProfilePIC)
        {
            [ProfilePIC getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *thumbnailImage = [UIImage imageWithData:data];
                UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
                
                
                SecondController.ProfilePicture = thumbnailImageView.image;
            }];
        }
        else SecondController.ProfilePicture =  [UIImage imageNamed:@"Default Profile.jpg"];
       
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
    [PostTable release];
    [_AddBtn release];
    [super dealloc];
}
- (IBAction)AddActionButton:(id)sender {
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"No button clicked");
            break;
        case 1:
            NSLog(@"Yes button clicked");
            [deleteObject deleteInBackground];
            [deleteObject saveInBackground];
            [self.PostTable reloadData];
            break;
            
        default:
            break;
    }
}
- (IBAction)DeleteBTN:(id)sender {
    UIButton *LikeButton = (UIButton * )sender;
    PFObject *tmp = [PostArray objectAtIndex:LikeButton.tag];
    
    NSString* Post_User = [tmp objectForKey:@"User"] ;
    if([Post_User isEqualToString:[PFUser currentUser].username])
    {
        deleteObject = tmp;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"You Sure you want to delete?" message:@"" delegate:self
                                                 cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView show];
        [alertView release];
    }
    else {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Cannot Delete Post"
                                                    message:@"Not Original Owner" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        [mes release];
    }
}
@end