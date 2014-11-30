//
//  UIViewController+PostComment.m
//  UCRChat
//
//  Created by user24887 on 11/29/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "PostComment.h"
#import "AddPostController.h"

@implementation PostComment

- (id)initWithCoder: (NSCoder *) aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Comment_Table.dataSource = self;
    self.Comment_Table.delegate = self;
    [self.Comment_Table reloadData];
}

- (void) PullData
{
    
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
    
    CGFloat cellcolor = 1.0 - (CGFloat)indexPath.row / 20.0;
    
    CustomCell *cell;
     cell.ColorView.backgroundColor = [UIColor colorWithWhite:cellcolor alpha:1.0];
    CommentPost* CurrentObject = [CPostArray objectAtIndex:indexPath.row];
    
    NSString* CellIdentifier = nil;
    if(CurrentObject->Photo) CellIdentifier = @"CommentSegue";
    else CellIdentifier = @"CommentPhotoSegue";
    
    cell = [tableView
            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    //Goin to obtain commenter's proile Picture
    cell.Commenter_Profile_Picture.image = CurrentObject.Profile_Image;
    
    //Going to obtain the User's Name
    cell.Commenter_Name.text = CurrentObject.User_Text;
    
    if([CellIdentifier isEqualToString:@"CommentSegue"])
        cell.Commenter_TextPost.text = CurrentObject.Post_text;
    else cell.Comenter_PhotoPost.image = CurrentObject.Post_Image;
        
    
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
}

- (void)dealloc {
    [_Comment_Table release];
    [super dealloc];
}
@end
