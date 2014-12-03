//
//  TimelineController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "TimelineController.h"
#import "AddPostController.h"
#import "CustomCell.h"
#import "PostViewController.h"
#import "PhotoViewPost.h"
#import "UserImage.h"
#import "MultimediaPost.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TimelineController ()
@end


@implementation TimelineController
@synthesize PostTable, Barbutton, AddBtn, navibar;
static int numLikes = 0;
static int numDislikes = 0;

PFObject *tempObject;
CustomCell *cell;


- (id)initWithCoder: (NSCoder *) aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        SavedPictures = [[NSMutableArray alloc] init];
        MultimediaPosts = [[NSMutableArray alloc] init];
        MyFriends = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) viewWillAppear: (BOOL) animated {
    [self PullParse];
    [self.PostTable reloadData];
    [self PullParse];
    [self.PostTable reloadData];
    [self PullParse];
    [self.PostTable reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MyFriends removeAllObjects];
    [PostArray removeAllObjects];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.PostTable setBackgroundColor: [UIColor clearColor]];
    [self.PostTable setOpaque: NO];
    self.PostTable.dataSource = self;
    self.PostTable.delegate = self;
    self.PostTable.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    
    [AddBtn setImage:[UIImage imageNamed:@"comment-icon.jpg"] forState:UIControlStateNormal];
    [Barbutton setImage:[UIImage imageNamed:@"camera.jpg"] forState:UIControlStateNormal];
    
    [Barbutton setTitle:@"  Photo" forState:UIControlStateNormal];
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.349 blue:0.596 alpha:0.5]];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(PullParse) forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PullParse) userInfo:nil repeats:YES];
    
  
    [self.PostTable addSubview:_refreshControl];
    [self.PostTable reloadData];
}

- (void) PullParse
{
    NSString *friendId = [PFUser currentUser ].username;
    NSString *friendName = [PFUser currentUser][@"fullName"];
    PFQuery *retrievePosts = [PFQuery queryWithClassName:@"GlobalTimeline"];
    [retrievePosts orderByDescending:@"createdAt"];
    [retrievePosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             PostArray = [[NSMutableArray alloc ] initWithArray:objects];
            // MyFriends  = PostArray;
            // dispatch_async(dispatch_get_main_queue(), ^{
                
                
                 // going to look for the objects to be displayed and only grabbing the users
                 //friends or his posts and ave dthem into the myFriends Array
                 for(PFObject* item in PostArray)
                 {
                     bool found_user = false;
                     if([item[@"User"] isEqualToString:friendId]) found_user = true;
                     else
                     {
                         for(NSString* string in item[@"Visibility"])
                         {
                            if([string isEqualToString:friendName])
                             {
                                 found_user = true;
                                 break;
                             }
                         }
                     }
                     
                     
                     bool insert = false;
                     if(found_user && item != nil)
                     {
                         for(PFObject* x in MyFriends)
                         {
                             if([x.objectId isEqualToString: item.objectId])
                             {
                                 insert = true;
                                 break;
                             }
                         }
                         if(!insert)
                             [MyFriends addObject:item];
                         
                         insert = false;
                     }
                        found_user = false;
                 }

            // });
         
         }
             
         [self.PostTable reloadData];
         [_refreshControl endRefreshing];
     }];
    
    PFQuery *retrieve = [PFQuery queryWithClassName:@"_User"];
    [retrieve findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             userarray = [[NSArray alloc ] initWithArray:objects];
         }
     }];
    
    [self Pull_Profile_pics];
    [self Pull_Mutimedia_data];
    [self.PostTable reloadData];
   
}

- (void) Pull_Profile_pics
{
    bool found_object = false; //To be used when we look if we already downloaded multiedia data object
    PFFile* PICTURE = nil; // Place holder for the file downloaded
    NSURL* imageURL = nil; //Place holder URL of file to be downloaded
    NSData* idata = nil; // Place holder The data for the file
    
    //Begin search
    for(PFObject* object in userarray)
    {
        //Check if theres a user already saved with an image
        for(UserImages* check in SavedPictures)
        {
            //if found then just update the picture-------------------------
            if([object[@"username"] isEqualToString:check.objectID])
            {
                found_object = true;                                        //Check for Uploading Date Then replace if neccessary (Major speed change)
                //check.Image = [UIImage imageWithData:idata];
                break;
            }
           // ---------------------------------------------------------------
        }
         //If the User Picture was not in our array then we need to add it
         if(found_object == false)
         {
             //download the pic and add the information to our array
             PICTURE = [object objectForKey:@"picture"];
             if(PICTURE){
                 imageURL = [[NSURL alloc] initWithString:PICTURE.url];
                 idata = [NSData dataWithContentsOfURL:imageURL];
            
             
                 //Creating the nw user onto our array
                 UserImages *UserPic = [[UserImages alloc] init];
                 UserPic.objectID = [object objectForKey:@"username"];
                 UserPic.Image = [UIImage imageWithData:idata];
                 [SavedPictures addObject:UserPic];
             }
         }
    }

}
- (void) Pull_Mutimedia_data
{
    //To be used when we look if we arady downloaded multiedia data object
    bool found_object = false;
    PFFile* PICTURE = nil; // Place holder for the file downloaded
    NSURL* imageURL = nil; //Place holder URL of file to be downloaded
    NSData* idata = nil; // Place holder The data for the file
    
    //Begin search
    for(PFObject* object in MyFriends)
    {
        //To be used to check if the object is a photo object
        NSNumber* Photo = object[@"PhotoPost"];
        
        //If the value it true then we are dealing with Photo file
        //We re going to check now if we have downloaded the the latest photo
        //or have not downloaded yet.
        if([Photo boolValue] == true)
        {
            //We are goin to check if we have the object saved in our system
            for(MultimediaPost* Post in MultimediaPosts)
            {
                //If we do own the object the we will check if we have the latest photo else we replace it
                 if([object[@"User"] isEqualToString:Post.UserID] && [object.objectId isEqualToString:Post.objectID])
                 {
                     found_object = true;
                     break;
                 }
            }
            //If the Picture was not in our array then we need to add it
            if(found_object == false)
            {
                //download the pic and add the information to our array
                PICTURE = [object objectForKey:@"MultimediaPost"];
                imageURL = [[NSURL alloc] initWithString:PICTURE.url];
                idata = [NSData dataWithContentsOfURL:imageURL];
                
                //creating the new object wit the data
                MultimediaPost *UserPic = [[MultimediaPost alloc] init];
                UserPic.UserID = [object objectForKey:@"User"];
                UserPic.objectID = object.objectId;
                UserPic.Image = [UIImage imageWithData:idata];
                [MultimediaPosts addObject:UserPic];
            }
            //resetting the found for next object to be search
            found_object = false;
        }
        
        //Now time to hanle Video downoads
        NSNumber* Video = object[@"VideoPost"];
        found_object = false; //Resetting our found variable
        
        //If the value it true then we are dealing with Video file
        //We re going to check now if we have downloaded the the latest Video
        //or have not downloaded yet.
        if([Video boolValue] == true)
        {
            //We are goin to check if we have the object saved in our system
            for(MultimediaPost* Post in MultimediaPosts)
            {
                //If we do own the object then We are done
                if([object[@"User"] isEqualToString:Post.UserID] && [object.objectId isEqualToString:Post.objectID])
                {
                    found_object = true;
                    break;
                }
            }
            
            //If the Video was not in our array then we need to add it
            if(found_object == false)
            {
                //download the Video and add the information to our array
                PICTURE = [object objectForKey:@"MultimediaPost"];
                imageURL = [[NSURL alloc] initWithString:PICTURE.url];
                
                //creating the new object wit the data
                MultimediaPost *UserPic = [[MultimediaPost alloc] init];
                UserPic.UserID = [object objectForKey:@"User"];
                UserPic.objectID = object.objectId;
                UserPic.Image = nil;
                UserPic.VideoURL = imageURL;
                UserPic.Movie = [[MPMoviePlayerController alloc]initWithContentURL:imageURL];
                [MultimediaPosts addObject:UserPic];
            }
            found_object = false;
        }
    }
    
}


//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return MyFriends.count;
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [PostTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [PostTable setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Divider_line@2x.png"]]];

    
    //setup cell
    tempObject = [MyFriends objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = nil;
    NSNumber* mybool =  tempObject[@"PhotoPost"];
    NSNumber* mybool2 = tempObject[@"VideoPost"];
    bool paidBoolean =  [mybool boolValue];
    bool paidBoolean2 = [mybool2 boolValue];
    
    if(paidBoolean == false && paidBoolean2 == false) CellIdentifier = @"mycell";
    else if(paidBoolean == true && paidBoolean2 == false) CellIdentifier = @"mycell2";
    else if(paidBoolean == false && paidBoolean2 == true) CellIdentifier = @"mycell2";

    
    cell = [tableView
            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.Likebtn.tag = indexPath.row;
    cell.Dislikebtn.tag = indexPath.row;
    cell.Delete.tag = indexPath.row;
    [[cell Likebtn] addTarget:self action:@selector(LikeBTNUP:) forControlEvents:UIControlEventTouchUpInside];
    [[cell Dislikebtn] addTarget:self action:@selector(DislikeBTNUP:) forControlEvents:UIControlEventTouchUpInside];
    [[cell Delete] addTarget:self action:@selector(DeleteBTN:) forControlEvents:UIControlEventTouchUpInside];
    
    //To obtain the full name from the user on this cell
    NSString* User = [tempObject objectForKey:@"User"];
    cell.IMG.image = [UIImage imageNamed:@"Default Profile.jpg"];

    for(PFObject* item in userarray)
    {
        if([[item objectForKey:@"username"] isEqualToString:User])
        {
            cell.NAME.text = item[@"fullName"];
            break;
        }
    }
    
    for(UserImages* x in SavedPictures)
    {
        if([tempObject[@"User"] isEqualToString:x.objectID]){
            cell.IMG.image = x.Image;
            break;
        }
    }
    
    
    //Obtain date of posts and output the date according to its date posted
    
    //date creted
    NSDate *CreatedAT = tempObject.createdAt;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM dd, YYYY";
    NSString* datetemp = [formatter stringFromDate:CreatedAT];
    
    //Todays Date
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM dd, YYYY";
    NSString* TodayDate = [dateFormatter stringFromDate:currDate];
    
    if([datetemp isEqualToString:TodayDate])
    {
        
        //currnt hour
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currDate];
        NSInteger hour  = [components hour];
        NSInteger min   = [components minute];
        
        
        //post hour
        calendar = [NSCalendar currentCalendar];
        components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:CreatedAT];
        NSInteger hour2 = [components hour];
        NSInteger min2  = [components minute];
        
        NSInteger Hours = hour - hour2;
        NSInteger Minutes = min - min2;
        NSString* str = nil;
        if(Hours > 0) {
             str = [NSString stringWithFormat: @"%ld", Hours];
             str = [str stringByAppendingString:@" hrs Ago"];
        }
        else {
             str = [NSString stringWithFormat: @"%ld", Minutes];
             str = [str stringByAppendingString:@" mins Ago"];
        }
        cell.Date.text = str;
        
    }
    else
    {
        cell.Date.text = datetemp;
    }
    
    if(paidBoolean == false && paidBoolean2 == false)
    {
        
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        bool found = false;
        NSArray *matches = [linkDetector matchesInString:[tempObject objectForKey:@"Post"] options:0 range:NSMakeRange(0, [[tempObject objectForKey:@"Post"] length])];
        for (NSTextCheckingResult *match in matches)
        {
            if ([match resultType] == NSTextCheckingTypeLink) {
                NSURL *url = [match URL];
                
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[tempObject objectForKey:@"Post"]];
                [str addAttribute: NSLinkAttributeName value:url range: match.range];
                cell.POST.attributedText = str;
                found = true;
                break;
            }
        }
        if(!found)cell.POST.text = [tempObject objectForKey:@"Post"];
    }
    
    
    else if(paidBoolean == true && paidBoolean2 == false)
    {
       
        for(MultimediaPost* x in MultimediaPosts)
        {
            if([tempObject[@"User"] isEqualToString:x.UserID] && [tempObject.objectId isEqualToString:x.objectID]){
                cell.PICPOST.image = x.Image;
                break;
            }
        }
    }
    
   else if(paidBoolean == false && paidBoolean2 == true)
    {
        for(MultimediaPost* x in MultimediaPosts)
        {
            if([tempObject[@"User"] isEqualToString:x.UserID] && [tempObject.objectId isEqualToString:x.objectID])
            {
                x.Movie.shouldAutoplay = NO;
               
                UIImage *thumbnail = [x.Movie thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                cell.PICPOST.image = thumbnail;
 
                break;
            }
        }
    }
    

    numLikes = [[tempObject objectForKey:@"Likes"] intValue];
    cell.LikeText.text = [NSString stringWithFormat:@"%d", numLikes ];
    numDislikes = [[tempObject objectForKey:@"Dislikes"] intValue];
    cell.DislikeText.text = [NSString stringWithFormat:@"%d", numDislikes ];
    
    //Check if we already lked the post to change the button text
    NSArray* temp_array = [tempObject objectForKey:@"LikesID"];
    NSArray* temp2_array = [tempObject objectForKey:@"DislikesID"];
    for (NSString* Item in temp_array) {
        if([[PFUser currentUser].username isEqualToString:Item])
            [cell.Likebtn setTitle:@"Liked" forState:UIControlStateNormal];
    }
    for (NSString* Item in temp2_array) {
        if([[PFUser currentUser].username isEqualToString:Item])
            [cell.Dislikebtn setTitle:@"Disliked" forState:UIControlStateNormal];
    }
 

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"CellSegue" sender:indexPath];
}
- (IBAction)LikeBTNUP:(id)sender {
    
    UIButton *LikeButton = (UIButton * )sender;
    PFObject *tmp = [MyFriends objectAtIndex:LikeButton.tag];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    NSIndexPath *indexPath = [self.PostTable indexPathForCell:sender];
    PFObject * tmp = [MyFriends objectAtIndex:indexPath.row];
    
    if ([[segue identifier] isEqualToString:@"Postsegue"])
    {
        //Creating the controller vieww where i will send the information
        AddPostController *PostController = segue.destinationViewController;
        PostController.Identifier = @"Postsegue";
        
    }
    if ([[segue identifier] isEqualToString:@"CellSegue"])
    {
       
        PostViewController *SecondController = segue.destinationViewController;
        
        //To obtain the full name from the user on this cell
        NSString* User = [tmp objectForKey:@"User"];
        int check = 0;
        for(PFObject* item in userarray)
        {
            if([[item objectForKey:@"username"] isEqualToString:User]){
                SecondController.PARENT_NAME = item[@"fullName"];
                check++;
            }
            if([item.objectId isEqualToString:[PFUser currentUser].objectId]){
                SecondController.CurrentUserNAME = item[@"fullName"];
                check++;
            }
            if(check == 2) break;
        }
        
        check = 0;
        for(UserImages* x in SavedPictures)
        {
            if([tmp[@"User"] isEqualToString:x.objectID]){
                SecondController.ProfilePicture = x.Image;
                check++;
            }
            
            if([[PFUser currentUser].username isEqualToString:x.objectID]){
                SecondController.CurrentUserImage = x.Image;
                check++;
            }
            if(check == 2) break;
        }
       
        SecondController.UserObject = tmp;
        SecondController.PARENT_POST = [tmp objectForKey:@"Post"];
        SecondController.CurrentObject = tmp;
        
    }
    if ([[segue identifier] isEqualToString:@"PhotoSegue"])
     {
        PhotoViewPost *SecondController = segue.destinationViewController;
         //To obtain the full name from the user on this cell
         NSString* User = [tmp objectForKey:@"User"];
         
         int check = 0;
         for(PFObject* item in userarray)
         {
             if([[item objectForKey:@"username"] isEqualToString:User]){
                 SecondController.PARENT_NAME = item[@"fullName"];
                 check++;
             }
             if([item.objectId isEqualToString:[PFUser currentUser].objectId]){
                 SecondController.CurrentUserNAME = item[@"fullName"];
                 check++;
             }
             if(check == 2) break;
         }
         
         check = 0;
         for(UserImages* x in SavedPictures)
         {
             if([tmp[@"User"] isEqualToString:x.objectID]){
                 SecondController.Picture = x.Image;
                 check++;
             }
             if([[PFUser currentUser].username isEqualToString:x.objectID]){
                 SecondController.CurrentUserImage = x.Image;
                 check++;
             }
             if(check == 2) break;
         }
         
         SecondController.UserObject = tmp;
         SecondController.CurrentObject = tmp;
         NSNumber* mybool =  tmp[@"PhotoPost"];
         NSNumber* mybool2 = tmp[@"VideoPost"];
         bool Photo =  [mybool boolValue];
         bool Video = [mybool2 boolValue];
         
         for(MultimediaPost* o in MultimediaPosts)
         {
             if([tmp.objectId isEqualToString:o.objectID]){
                 SecondController.PARENT_POST = o.Image;
                 if(Photo) SecondController.POST = o.Image;
                 else if(Video) SecondController.VideoURL = o.VideoURL;
                break;
             }
         }
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
    [PostTable release];
    [AddBtn release];
    [Barbutton release];
    [navibar release];
    [_AppName release];
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
    PFObject *tmp = [MyFriends objectAtIndex:LikeButton.tag];
    
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

- (IBAction)DislikeBTNUP:(id)sender {
    
    UIButton *DislikeButton = (UIButton * )sender;
    PFObject *tmp = [MyFriends objectAtIndex:DislikeButton.tag];
    
    NSMutableArray* tmp_Array = [tmp objectForKey:@"DislikesID"] ;
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
                 
                 [tmp incrementKey:@"Dislikes" byAmount:[NSNumber numberWithInt:1]];
                 [tmp addUniqueObject:[PFUser currentUser].username forKey:@"DislikesID"];
                 [tmp saveInBackground];
                 [DislikeButton setTitle:@"Disliked" forState:UIControlStateNormal];
                 [self.PostTable reloadData];
                 cell.LikeText.text = [NSString stringWithFormat:@"%d", [[tmp objectForKey:@"Dislikes"] intValue]];
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
                 [tmp incrementKey:@"Dislikes" byAmount:[NSNumber numberWithInt:-1]];
                 //Obtain array of LIKESId
                 for(id item in tmp_Array)
                 {
                     if([item isEqualToString:[PFUser currentUser].username]){
                         [tmp_Array removeObject: item];
                         [tmp saveInBackground];
                         [DislikeButton setTitle:@"Dislike" forState:UIControlStateNormal];
                         [self.PostTable reloadData];
                         
                     }
                 }
                 
             }
         }];
    }

}

@end