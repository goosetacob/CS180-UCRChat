//
//  addFriend.m
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "addFriend.h"
#import <Parse/Parse.h>
#import "TableCell.h"

@interface addFriend ()

@end


@implementation addFriend

@synthesize addFriendTableView;

// Gets a full list of Users from Parse
- (void) retrieveFromParse
{
    PFQuery *ret = [PFQuery queryWithClassName:@"_User"];
    [ret findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if( !error )
        {
            [addFriendsArray addObjectsFromArray:objects ];
            while( [self tableView:addFriendTableView numberOfRowsInSection:0] != [addFriendsArray count])
            {
                [self.addFriendTableView reloadData ];
            }
            NSLog( @"addFriends/Size of all users: %lu", objects.count );
        }
        else
        {
            NSLog( @"ERROR querying data!");
        }
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [addFriendTableView setDataSource:self];
    [addFriendTableView setDelegate:self];
    addFriendsArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    [self retrieveFromParse];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToFriends:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)sendFriendRequest:(UIBarButtonItem *)sender
{
    
    
}

// We will use this method to receive data from the main 'Friends' tab.
- (void)setMyObjectHere:(id)data
{
    selectedFriend = data;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // In our Friends View Controller, the number of rows in our Table View depends on how many friends we have
    //return Friends.count;
    
    NSLog( @"addFriends/numberofRows: %lu", addFriendsArray.count );
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
    
    if( indexPath.row > addFriendsArray.count )
    {
        NSLog(@"indexPath row is bigger than addFriendsArray...aborting...");
        return cell;
        
    }
    // Populate cell using Friend information at specific row
    PFObject *object = [addFriendsArray objectAtIndex:indexPath.row];
    
    NSLog(@"tableview/addFriends: %@", [object objectForKey:@"fullName"] );
    cell.TitleLabel.text = [object objectForKey:@"fullName"];
    cell.DescriptionLabel.text = [object objectForKey:@"aboutMe"];
    //cell.ThumbImage.image = [object objectForKey:@"picture"];
    
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
