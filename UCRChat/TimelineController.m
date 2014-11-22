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

@interface TimelineController ()

@end


@implementation TimelineController
@synthesize PostTable;
static int numLikes = 0;
static NSUInteger numComments = 0;

PFObject *tempObject;
CustomCell *cell;
NSMutableArray* SavedPictures = nil;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.PostTable setBackgroundColor: [UIColor clearColor]];
    [self.PostTable setOpaque: NO];
    self.PostTable.dataSource = self;
    self.PostTable.delegate = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(PullParse) forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(retrieveFromParse) userInfo:nil repeats:YES];
    
    
    [self.PostTable addSubview:_refreshControl];
    [self.PostTable reloadData];
    
    
   // [self retrieveFromParse ];
    
    
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
    
    for(PFObject* i in PostArray)
    {
        i[@"Refresh"] = [NSNumber numberWithInt:0];
        [i saveInBackground];
        
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
    
    for(PFObject* i in PostArray)
    {
        [i incrementKey:@"Refresh" byAmount:[NSNumber numberWithInt:1]];
        [i saveInBackground];

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
    
    static NSString *CellIdentifier = @"mycell";
    
    cell = [tableView
            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.Likebtn.tag = indexPath.row;
    cell.CommentBtn.tag = indexPath.row;
    cell.Delete.tag = indexPath.row;
    [[cell Likebtn] addTarget:self action:@selector(LikeBTNUP:) forControlEvents:UIControlEventTouchUpInside];
    [[cell CommentBtn] addTarget:self action:@selector(commentBTNUP:) forControlEvents:UIControlEventTouchUpInside];
    [[cell Delete] addTarget:self action:@selector(DeleteBTN:) forControlEvents:UIControlEventTouchUpInside];
    cell.NAME.text = [tempObject objectForKey:@"User"];

    //To obtain the full name from the user on this cell
    NSString* User = [tempObject objectForKey:@"User"];
    //cell.IMG.image = [UIImage imageNamed:@"Default Profile.jpg"];

    PFFile* PICTURE = nil;
    for(PFObject* item in userarray)
    {
        if([[item objectForKey:@"username"] isEqualToString:User])
        {
            cell.NAME.text = item[@"fullName"];
            PICTURE = [item objectForKey:@"picture"];
            break;
        }
    }
    
    
    if(PICTURE) {
        if([tempObject[@"Refresh"]intValue] < 1 || [tempObject[@"Refresh"]intValue] % 10 == 0){
            NSURL* imageURL = [[NSURL alloc] initWithString:PICTURE.url];
            NSData* idata = [NSData dataWithContentsOfURL:imageURL];
            cell.IMG.image = [UIImage imageWithData:idata];
        
            UserImages *UserPic = [[UserImages alloc] init];
            UserPic.objectID = tempObject.objectId;
            UserPic.Image = [UIImage imageWithData:idata];
            [SavedPictures addObject:UserPic];
            }
    }
    if([tempObject[@"Refresh"]intValue] >= 1)
    {
        for(UserImages* item in SavedPictures)
        {
            if([item.objectID isEqualToString:tempObject.objectId]){
                NSLog(@"Object found");
                cell.IMG.image = item.Image;
                break;
            }
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
        
        for(PFObject* item in userarray)
        {
            if([[item objectForKey:@"username"] isEqualToString:User]){
                SecondController.PARENT_NAME = item[@"fullName"];
                break;
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
            
            
            for(PFObject* item in PostArray)
            {
                item[@"Refresh"] =[NSNumber numberWithInt:0];
                [item saveInBackground];
            }
            
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