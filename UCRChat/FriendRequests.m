//
//  FriendRequests.m
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <Parse/Parse.h>
#import "FriendRequests.h"

@interface FriendRequests ()

@end

@implementation FriendRequests

@synthesize friendRequestsTableView;

- (void)getFriendRequests
{
    PFUser *current_user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:current_user[@"friendClassId"] block:^(PFObject *object, NSError *error)
     {
         if (!error) {
             for( NSString *user in object[@"friendRequests"])
             {
                 PFQuery *query2 = [PFQuery queryWithClassName:@"_User"];
                 [query2 getObjectInBackgroundWithId:user block:^(PFObject *fobject, NSError *error) {
                     if( !error )
                     {
                         [friend_requests addObject:fobject];
                         
                         [self.friendRequestsTableView reloadData];

                     }
                     else
                         NSLog(@"Error trying to query Parse!");
                 }];
                 
             }
         }
         else
             NSLog ( @"Failed to query Parse!\n");
         
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [friendRequestsTableView setDataSource:self];
    [friendRequestsTableView setDelegate:self];

    friend_requests = [[NSMutableArray alloc] init];

    [self getFriendRequests];
}

- (void) viewWillAppear:(BOOL)animated
{
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backToMyFriends:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


// Sends a friend request
- (IBAction)acceptFriendRequest:(UIBarButtonItem *)sender
{
    // Determine what cell we are in based off button press
    CGPoint buttonPosition = [(id)sender convertPoint:CGPointZero toView:self.friendRequestsTableView];
    NSIndexPath *indexPath = [self.friendRequestsTableView indexPathForRowAtPoint:buttonPosition];
    
    // Now that we have the cell, we know what user to send a friend request to.
    TableCell *cell = (TableCell*)[self.friendRequestsTableView cellForRowAtIndexPath:indexPath];
    PFUser *accept_user = [cell getUser];
    
    NSLog(@"Accepting a friend %@!", accept_user);
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:accept_user[@"friendClassId"] block:^(PFObject *object, NSError *error) {
        if( !error )
        {
            NSMutableArray *friends = [[NSMutableArray alloc] initWithArray:object[@"Friends"]];
            [friends addObject:[PFUser currentUser].objectId];
            object[@"Friends"] = friends;
            [object saveInBackground];
            
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Friends"];
    [query2 getObjectInBackgroundWithId:[PFUser currentUser][@"friendClassId"] block:^(PFObject *object, NSError *error) {
        if( !error )
        {
            NSMutableArray *friends = [[NSMutableArray alloc] initWithArray:object[@"Friends"]];
            [friends addObject:accept_user.objectId];
            object[@"Friends"] = friends;
            [object saveInBackground];
        }
    }];
    
    PFQuery *query3 = [PFQuery queryWithClassName:@"Friends"];
    [query3 getObjectInBackgroundWithId:[PFUser currentUser][@"friendClassId"] block:^(PFObject *object, NSError *error) {
        if( !error )
        {
            for( NSString* requests in object[@"friendRequests"])
            {
                if( [requests isEqualToString:accept_user.objectId] )
                {
                    [object[@"friendRequests"] removeObject:requests];
                    [object saveInBackground];
                    break;
                }
            }
        }
    }];
    
    [friend_requests removeObject:accept_user];
    [friendRequestsTableView reloadData];
}

// Sends a friend request
- (IBAction)declineFriendRequest:(UIBarButtonItem *)sender
{
    // Determine what cell we are in based off button press
    CGPoint buttonPosition = [(id)sender convertPoint:CGPointZero toView:self.friendRequestsTableView];
    NSIndexPath *indexPath = [self.friendRequestsTableView indexPathForRowAtPoint:buttonPosition];
    
    // Now that we have the cell, we know what user to send a friend request to.
    TableCell *cell = (TableCell*)[self.friendRequestsTableView cellForRowAtIndexPath:indexPath];
    PFUser *decline_user = [cell getUser];
    
    NSLog(@"Declining a friend %@!", decline_user[@"fullName"]);
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:decline_user[@"friendClassId"] block:^(PFObject *object, NSError *error) {
        if( !error )
        {
            for( NSString* user_to_decline in object[@"friendRequests"] )
            {
                if( [user_to_decline isEqualToString:decline_user.objectId] )
                {
                    [object[@"friendRequests"] removeObject:user_to_decline];
                    [object saveInBackground];
                    break;
                }
            }
        }
    }];
    
    [friend_requests removeObject:decline_user];
    [friendRequestsTableView reloadData];
}

// We will use this method to receive data from the main 'Friends' tab.
- (void)setMyObjectHere:(NSString *)data
{
    
    // Query objectID to grab Friends array
    /*PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:data block:^(PFObject *object, NSError *error)
     {
         if (!error) {
            for( NSString* requests in object[@"friendRequests"])
            {
                NSLog(@"Found friend request from: %@", requests);
                
            }
             
            if( [object[@"friendRequests"] count ] == 0)
                NSLog( @"friendRequests/setMyObjectHere: Found no friend requests.");
         }
         else
             NSLog ( @"Failed to query User!\n");
         
     }];*/
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // In our Friends View Controller, the number of rows in our Table View depends on how many friends we have
    return friend_requests.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell3";
    TableCell *cell = [self.friendRequestsTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    
    // If we have no cells, initialize it
    if( !cell )
    {
        cell = [ [TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier ];
    }
    
    //if( indexPath.row > Friends.count )
    //return cell;
    
    // Populate cell using Friend information at specific row
    PFObject *object = [friend_requests objectAtIndex:indexPath.row];
    
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
