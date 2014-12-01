//
//  MyFriends.m
//  UCRChat
//
//  Created by user26338 on 11/12/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "MyFriends.h"
#import "FriendRequests.h" // FriendRequests segue reference
#import "friendsInfo.h"    // friendsInfo segue reference
#import "addFriend.h"      // addFriends segue reference
#import <Parse/Parse.h>
#import "TableCell.h"


@interface MyFriends ()

@end

@implementation MyFriends


@synthesize myTableView;
@synthesize groupName;

- (void) getFriends
{
    // Get ObjectID of current user
    NSString *friendId = [PFUser currentUser ][@"friendClassId"];
    
    // Query objectID to grab Friends array
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:friendId block:^(PFObject *object, NSError *error)
     {
         if (!error) {
             // Do something with the found friend array

             for (NSUInteger i = 0; i < [object[@"Friends"] count]; ++i)
             {
                 
                 NSString *friend = object[@"Friends"][i];
                 
                 // Make another query for each friend objectId obtained from the friends array.=
                 PFQuery *friendQuery = [PFQuery queryWithClassName:@"_User"];
                 
                 // Query a second time to get one specific friend ObjectId.
                 [friendQuery getObjectInBackgroundWithId:friend block:^(PFObject *fobject, NSError *error)
                  {
                      // We've grabbed on PFObject from our array of friends. Now we parse through our Friends array
                      if (!error)
                      {
                          // Compare new PFObject to our current list of friends
                          NSInteger exists = 0;
                          for( PFObject* j in Friends )
                          {
                              if( [(NSString*)j.objectId isEqualToString:fobject.objectId] )
                                  exists = 1;
                          }
                          
                          // If we have a unique friend, add it to our Friend array
                          if( exists == 0 )
                              [Friends addObject:fobject ];
                          
                          // This is critical for making sure our cells are correctly up-to-date on screen!
                          [self.myTableView reloadData];
                          
                      }
                      else
                      {
                          // Log details of the failure
                          NSLog(@"Error: %@ %@", error, [error userInfo]);
                      }
                      
                  }];
                 
                 
             }
             
             
             
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

- (void) viewDidAppear:(BOOL)animated
{
    // Initialize mutable arrays
    if(Friends.count <= 0)
        Friends = [[NSMutableArray alloc] init];
    
    if(Groups.count <= 0)
        Groups = [[NSMutableArray alloc] init];
    
    
    // Refresh array everytime view reloads
    [Friends removeAllObjects];
    [Groups removeAllObjects];
    
    // Grab list of friends and refresh tableview
    [self getFriends];
    [myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set TableView delegate and data source
    [myTableView setDataSource:self];
    [myTableView setDelegate:self];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Send current user's info to keep track of friend requests
    if ([[segue identifier] isEqualToString:@"friendRequests"])
    {
        // Get reference to the destination view controller
        FriendRequests *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        NSString *currId = [PFUser currentUser ][@"friendClassId"];

        [vc setMyObjectHere:currId];
    }
    
    // Send mutual friends maybe? Not required much for this view...
    else if( [[segue identifier] isEqualToString:@"addFriends"])
    {
        // Get reference to the destination view controller
        addFriend *vc = [segue destinationViewController];
        

        [vc setMyObjectHere:Friends];
    }
    
    // Send friendInformation
    else if( [[segue identifier] isEqualToString:@"friendsInfo"] )
    {
        // Get reference to the destination view controller
        friendsInfo *vc = [segue destinationViewController];
        
        [vc setMyObjectHere:selectedFriend andArray: Friends withGroups: Groups];
    }
}

#pragma tableView datasrouce and delegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //return 1 + Groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // In our Friends View Controller, the number of rows in our Table View depends on how many friends we have

    //if( section == 0 )
        return Friends.count;
    //else
      //  return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get friend that corresponds to the cell
    selectedFriend = [Friends objectAtIndex:indexPath.row];
    
    // Perform segue when cell has been clicked. Friend data will be sent
    [self performSegueWithIdentifier:@"friendsInfo" sender:self];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //if( section == 0)
        return @"All Friends";
    //else
      //  return Groups[section];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if( indexPath.section == 0 && indexPath.row < Friends.count )
    //{
        static NSString *CellIdentifier = @"TableCell";
        TableCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    
        // If we have no cells, initialize it
        if( !cell )
        {
            cell = [ [TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier ];
        }
    
        // Populate cell using Friend information at specific row
        PFObject *object = [Friends objectAtIndex:indexPath.row];
    
        cell.TitleLabel.text = [object objectForKey:@"fullName"];
    
        cell.DescriptionLabel.text = [object objectForKey:@"aboutMe"];
    
        PFFile *imagefile = [object objectForKey:@"picture"];
        NSURL* imageURL = [[NSURL alloc] initWithString:imagefile.url];
        NSData* image = [NSData dataWithContentsOfURL:imageURL ];
        cell.ThumbImage.image = [UIImage imageWithData:image];
        return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)enteredNewGroup:(id)sender {
    [Groups addObject:groupName.text];
}


- (void)dealloc {
    [groupName release];
    [super dealloc];
}
@end
