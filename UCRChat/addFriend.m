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
                    if ( [user.objectId isEqualToString: [(PFObject *)friend objectId]] )
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.addFriendTableView];
    NSIndexPath *indexPath = [self.addFriendTableView indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [self.addFriendTableView cellForRowAtIndexPath:indexPath];
    
    NSLog( @"User name in cell: %@", [[(TableCell*)cell getUser] objectForKey:@"fullName"]);
    
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
    //cell.ThumbImage.image = [object objectForKey:@"picture"];
    
    [cell setUser:object ];
    
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
