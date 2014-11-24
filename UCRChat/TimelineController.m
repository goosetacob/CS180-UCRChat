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
#import "UserImage.h"
#import "MultimediaPost.h"

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(retrieveFromParse) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(PullParse) userInfo:nil repeats:YES];
    
    [self.PostTable addSubview:_refreshControl];
    [self.PostTable reloadData];
    
    
}

- (void) PullParse
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
    
    bool Found = false;
    for(PFObject* i in userarray)
    {
        PFFile* PICTURE = [i objectForKey:@"picture"];
        NSURL* imageURL = [[NSURL alloc] initWithString:PICTURE.url];
        NSData* idata = [NSData dataWithContentsOfURL:imageURL];
        
        //Check if theres a user already saved
        for(UserImages* check in SavedPictures)
        {
            //if found then just update the picture
            if([i[@"username"] isEqualToString:check.objectID])
            {
                Found = true;
                check.Image = [UIImage imageWithData:idata];
                break;
            }
        }
        
        //if its not ssaved then add it to the list
        if(!Found){
        
            UserImages *UserPic = [[UserImages alloc] init];
            UserPic.objectID = [i objectForKey:@"username"];
            UserPic.Image = [UIImage imageWithData:idata];
            [SavedPictures addObject:UserPic];
        }
    }
   
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
    /*
    NSNumber* mybool = 0;
    for(PFObject* items in PostArray)
    {
        mybool = items[@"PhotoPost"];
        if([mybool boolValue] == true)
        {
            PFFile* PICTURE = [items objectForKey:@"picture"];
           // NSURL* imageURL = [[NSURL alloc] initWithString:PICTURE.url];
           // NSData* idata = [NSData dataWithContentsOfURL:imageURL];
            
            MultimediaPost* UserPost = [[MultimediaPost alloc] init];
            //UserPost.objectID = [items objectForKey:@"username"];
            //UserPost.Image = [UIImage imageWithData:idata];
            //[MultimediaPosts addObject:UserPost];
        }
    }
    */
    bool Found = false;
    for(PFObject* i in PostArray)
    {
        NSNumber* mybool = i[@"PhotoPost"];
        if([mybool boolValue] == true)
        {
            PFFile* PICTURE = [i objectForKey:@"MultimediaPost"];
            NSURL* imageURL = [[NSURL alloc] initWithString:PICTURE.url];
            NSData* idata = [NSData dataWithContentsOfURL:imageURL];
            
            //Check if theres a user already saved
            for(MultimediaPost* check in MultimediaPosts)
            {
                //if found then just update the picture
                if([i[@"User"] isEqualToString:check.UserID] && [i.objectId isEqualToString:check.objectID])
                {
                    Found = true;
                    check.Image = [UIImage imageWithData:idata];
                    break;
                }
            }
            
            //if its not saved then add it to the list
            if(!Found){
                
                MultimediaPost *UserPic = [[MultimediaPost alloc] init];
                UserPic.UserID = [i objectForKey:@"User"];
                UserPic.objectID = i.objectId;
                UserPic.Image = [UIImage imageWithData:idata];
                [MultimediaPosts addObject:UserPic];
            }
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
   // NSLog(@"%lu", (unsigned long)PostArray.count);
    return PostArray.count;
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [PostTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [PostTable setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Divider_line@2x.png"]]];
    CGFloat cellcolor = 1.0 - (CGFloat)indexPath.row / 20.0;
   
    cell.ColorView.backgroundColor = [UIColor colorWithWhite:cellcolor alpha:1.0];
    //setup cell
    tempObject = [PostArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = nil;
    NSNumber* mybool = tempObject[@"PhotoPost"];
    bool paidBoolean = [mybool boolValue];
    
    if(paidBoolean == false) CellIdentifier = @"mycell";
    else CellIdentifier = @"mycell2";
        

    
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
    
    if(paidBoolean == false)
        cell.POST.text = [tempObject objectForKey:@"Post"];
    else{
       
        //cell.PICPOST.image = nil;
        for(MultimediaPost* x in MultimediaPosts)
        {
            if([tempObject[@"User"] isEqualToString:x.UserID] && [tempObject.objectId isEqualToString:x.objectID]){
                cell.PICPOST.image = x.Image;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CellSegue"]){
        
       // NSIndexPath * indexPath = (NSIndexPath *) sender;
        NSIndexPath *indexPath = [self.PostTable indexPathForCell:sender];
        PFObject * tmp = [PostArray objectAtIndex:indexPath.row];
        
        //if you need to pass data to the next controller do it here
      //  UIButton *CommentButton = (UIButton * )sender;
       // PFObject *tmp = [PostArray objectAtIndex:CommentButton.tag];
        PostViewController *SecondController = segue.destinationViewController;
        
        //To obtain the full name from the user on this cell
        NSString* User = [tmp objectForKey:@"User"];
        
        for(PFObject* item in userarray)
        {
            if([[item objectForKey:@"username"] isEqualToString:User]){
                SecondController.PARENT_NAME = item[@"fullName"];
                break;
            }
        }
        
        for(UserImages* x in SavedPictures)
        {
            if([tmp[@"User"] isEqualToString:x.objectID]){
                SecondController.ProfilePicture = x.Image;
            }
        }
       
        SecondController.UserObject = tmp;
        SecondController.PARENT_POST = [tmp objectForKey:@"Post"];
        
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

- (IBAction)DislikeBTNUP:(id)sender {
    
    UIButton *DislikeButton = (UIButton * )sender;
    PFObject *tmp = [PostArray objectAtIndex:DislikeButton.tag];
    
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