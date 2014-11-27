//
//  addFriend.m
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "addFriend.h"

@interface addFriend ()

@end


@implementation addFriend

@synthesize addFriendTableView;

// Generate an array of available friends to add
- (void) retrieveFromParse
{
    PFQuery *ret = [PFQuery queryWithClassName:@"_User"];
    [ret findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if( !error )
        {
            // Traverse through all available users in Parse
            for( PFObject *user in objects)
            {
                // We only want users who are not your friend yet
                NSInteger exists = 0;
                for( NSString *friend in friends)
                {
                    // Exclude the current user as a possible friend as well
                    if ( [user.objectId isEqualToString: [(PFObject *)friend objectId]] || [user.objectId isEqualToString:[PFUser currentUser].objectId] )
                        exists = 1;
                }
                
                if( exists == 0 )
                    [addFriendsArray addObject:user];
            }
        }
        else
        {
            NSLog( @"ERROR querying data!");
        }

        
        // Reload the tableView ONLY when you've finished getting your array
        [self.addFriendTableView reloadData ];

    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set delegates
    [addFriendTableView setDataSource:self];
    [addFriendTableView setDelegate:self];
    
    // Initialize all arrays
    addFriendsArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    [self retrieveFromParse];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Sends the view back to friends list
- (IBAction)backToFriends:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


// Sends a friend request
- (IBAction)sendFriendRequest:(UIBarButtonItem *)sender
{
    // Determine what cell we are in based off button press
    CGPoint buttonPosition = [(id)sender convertPoint:CGPointZero toView:self.addFriendTableView];
    NSIndexPath *indexPath = [self.addFriendTableView indexPathForRowAtPoint:buttonPosition];
    
    // Now that we have the cell, we know what user to send a friend request to.
    TableCell *cell = (TableCell*)[self.addFriendTableView cellForRowAtIndexPath:indexPath];
    PFUser *user_to_add = [cell getUser];
    
    // Check the list of friend requests
    PFUser *current = [PFUser currentUser];
    __block NSInteger request_exists = 0;
    __block PFUser *user_to_add_friend_class;
    
    // We query Parse for the friends list by supplying the friendClassId of the user-to-be-added, which we got from clicking on the cell.
    PFQuery *friends_query = [PFQuery queryWithClassName:@"Friends"];
    [friends_query getObjectInBackgroundWithId:user_to_add[@"friendClassId"] block:^(PFObject *object, NSError *error)
    {
        if( !error )
        {
            user_to_add_friend_class = (PFUser*)object;
            
            // Make sure the request hasn't already been sent or if they're not friends already
            for( NSString *request in object[@"friendRequests"])
            {
                if( [request isEqualToString: current.objectId] )
                    request_exists = 1;
                
                // "Friend request already sent!"
            }
            for( NSString *friends_in_request in user_to_add[@"Friends"])
            {
                if( [friends_in_request isEqualToString: current.objectId] )
                    request_exists = 1;
            }
            
            if( request_exists == 0)
            {
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:object[@"friendRequests"]];
                [arr addObject:current.objectId];
                object[@"friendRequests"] = arr;
                [object saveInBackground];
            }
            else
                NSLog(@"Already sent a friend request!");
        }
        else
            NSLog(@"Error querying in Parse!");
    }];

    
    // Add user to array of friend requests and save object
    /*if( request_exists == 0)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
        [query getObjectInBackgroundWithId:user_to_add.objectId block:^(PFObject *object, NSError *error) {
            if( !error )
            {
                NSLog(@"%@", object);
                NSLog(@"Friend request sent!");
                if( [object[@"friendRequests"] count] == 0)
                    [object addUniqueObject:current.objectId forKey:@"friendRequests"];//object[@"friendRequests"][0] = current.objectId;
                else
                    [object addUniqueObject:current.objectId forKey:@"friendRequests"];//[object[@"friendRequests"] addObject:current.objectId ];

                
                    //////
                     if( [object[@"friendRequests"] count] == 0)
                     [object addUniqueObject:current.objectId forKey:@"friendRequests"];
                     else
                     [object addUniqueObject:current.objectId forKey:@"friendRequests"];
                    /////
                // Save updated user to Parse
                [object saveInBackground];
            }
        }];

    }*/

}


- (void)setMyObjectHere:(NSArray*)friend_list
{
    friends = friend_list;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addFriendsArray.count;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get friend that corresponds to the cell
    //selectedFriend = [Friends objectAtIndex:indexPath.row];
    
    // Perform segue when cell has been clicked. Friend data will be sent
    //[self performSegueWithIdentifier:@"friendsInfo" sender:self];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell2";
    TableCell *cell = [self.addFriendTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    
    // If we have no cells, initialize it
    if( !cell )
    {
        cell = [ [TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier ];
    }

    // Populate cell using Friend information at specific row
    PFObject *object = [addFriendsArray objectAtIndex:indexPath.row];
    
    //NSLog(@"tableview/addFriends: %@", [object objectForKey:@"fullName"] );

    cell.TitleLabel.text = [object objectForKey:@"fullName"];
    cell.DescriptionLabel.text = [object objectForKey:@"aboutMe"];
    
    PFFile *imagefile = [object objectForKey:@"picture"];
    NSURL* imageURL = [[NSURL alloc] initWithString:imagefile.url];
    NSData* image = [NSData dataWithContentsOfURL:imageURL ];
    
    cell.ThumbImage.image = [UIImage imageWithData:image];
    
    [cell setUser:(PFUser*)object ];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
