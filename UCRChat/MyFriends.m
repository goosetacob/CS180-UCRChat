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

BOOL done_loading = true;

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
                          
                          PFFile *imagefile = [fobject objectForKey:@"picture"];
                          if( imagefile != nil )
                          {
                              NSURL* imageURL = [[NSURL alloc] initWithString:imagefile.url];
                              NSData* image = [NSData dataWithContentsOfURL:imageURL ];
                              [images addObject: [UIImage imageWithData:image]];
                              
                          }
                          else
                              [images addObject: nil];
                          
                          // This is critical for making sure our cells are correctly up-to-date on screen!
                          [self.myTableView reloadData];
                          
                      }
                      else
                      {
                          // Log details of the failure
                          NSLog(@"Frend Parse Error: %@ %@", error, [error userInfo]);
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


- (void) getGroups
{
    // Get Groups objectId through Friends data
    PFQuery *friend_query = [PFQuery queryWithClassName:@"Friends"];
    NSMutableArray *group_ids = [[NSMutableArray alloc] init ];
  
    [friend_query getObjectInBackgroundWithId:[PFUser currentUser][@"friendClassId"] block:^(PFObject *object, NSError *error) {
        if (! error  )
        {
            [group_ids addObjectsFromArray:object[@"groupIds"]];
            
            // Traverse all groups once we grabbed our array from Friend data
            for( NSString* group_id in group_ids )
            {
                PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
                [query getObjectInBackgroundWithId:group_id block:^(PFObject *object, NSError *error) {
                    if( !error )
                    {
                        [Groups addObject:object];
                        [myTableView reloadData];
                    }
                    else
                        NSLog(@"groupIds: Error querying Parse!");
                }];
            }
        }
        else
            NSLog(@"Friends: Error querying Parse!");
    }];
    

}
- (void) viewWillAppear:(BOOL)animated
{
    if( done_loading == true )
    {
        //NSLog(@"viewDidAppear");
        // Initialize mutable arrays
        if(Friends.count <= 0)
            Friends = [[NSMutableArray alloc] init];
    
        if(Groups.count <= 0)
            Groups = [[NSMutableArray alloc] init];
    
        if(images.count <= 0)
            images = [[NSMutableArray alloc] init];
    
        // Refresh array everytime view reloads
        [Friends removeAllObjects];
        [Groups removeAllObjects];
        [images removeAllObjects];
    
        // Grab list of friends
        [self getFriends];
        [self getGroups];
        
        done_loading = false;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set TableView delegate and data source
    [myTableView setDataSource:self];
    [myTableView setDelegate:self];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"prepareForSegue");
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
    //NSLog(@"numberOfSectionsInTableView");
    //return 2;
    return 1 + Groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection");
    // In our Friends View Controller, the number of rows in our Table View depends on how many friends we have

    if( section == 0 )
        return Friends.count;
    else
    {
        return [[Groups[section-1] objectForKey:@"friendClassIdSet"] count ];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath");
    // Get friend that corresponds to the cell
    if( indexPath.section == 0)
        selectedFriend = [Friends objectAtIndex:indexPath.row];
    else
    {
        id object = nil;
        NSString* object_id = [[[Groups objectAtIndex:indexPath.section-1] objectForKey:@"friendClassIdSet"] objectAtIndex:indexPath.row ];
        
        for( PFObject *friend_ids in Friends)
        {
            if( [[friend_ids objectId] isEqualToString:object_id] )
                object = friend_ids;
        }
        selectedFriend = object;
    }
    // Perform segue when cell has been clicked. Friend data will be sent
    [self performSegueWithIdentifier:@"friendsInfo" sender:self];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSLog(@"titleForHeaderInSection");
    if( section == 0)
        return @"All Friends";
    else
        return [Groups[section-1] objectForKey:@"groupName"];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    
    // If we have no cells, initialize it
    if( !cell )
    {
        cell = [ [TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier ];

    }
    
    // Grab friend object based on what section we're in.
    id object = nil;
    if( indexPath.section == 0 )
    {
        // Populate cell using Friend information at specific row
        object = [Friends objectAtIndex:indexPath.row];
    }
    else
    {
        // Populate cell using the appropriate friend object in the Groups array
        NSString* object_id = [[[Groups objectAtIndex:indexPath.section-1] objectForKey:@"friendClassIdSet"] objectAtIndex:indexPath.row ];
        
        for( PFObject *friend_ids in Friends)
        {
            if( [[friend_ids objectId] isEqualToString:object_id] )
                object = friend_ids;
        }
    }
        
    cell.TitleLabel.text = [object objectForKey:@"fullName"];
    cell.DescriptionLabel.text = [object objectForKey:@"aboutMe"];
   
    // Wait until images array loads before we try populating the image in the cell
    if( [images count] >= indexPath.row )
    {
        // For Group array images
        if( indexPath.section != 0)
        {
            // Determine the appropriate image based off friend info
            for( NSInteger i = 0; i < [Friends count]; ++i)
            {
                id j = [Friends objectAtIndex:i];
                if( [object[@"fullName"] isEqualToString:[j objectForKey:@"fullName"]] )
                {
                    //NSLog(@"Number of images: %lu vs row: %lu", [images count], indexPath.row);
                    cell.ThumbImage.image = [images objectAtIndex:i ];
                    break;
                }
            }
        }
        // For 'All Friends' friend aray images
        else
            cell.ThumbImage.image = [images objectAtIndex:indexPath.row ];
    }

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

- (void)dealloc {
    [groupName release];
    [super dealloc];
}

- (IBAction)addGroup:(id)sender {
    // Dismiss the keboard
    [groupName resignFirstResponder];
    
    // Save group in Parse
    PFObject *new_group = [PFObject objectWithClassName:@"Groups"];
    new_group[@"groupName"] = groupName.text;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:[PFUser currentUser][@"friendClassId"] block:^(PFObject *object, NSError *error) {
        if( !error )
        {
            // Assigning Friend objectId to group row
            new_group[@"friendClassId"] = object.objectId;
            [new_group save]; // Save synchronously because groupIds depends on this
            [Groups addObject:new_group];
            
            // Saving group objectId to grops array in Friends
            [groups addObjectsFromArray:object[@"groupIds"]];
            [groups addObject:new_group.objectId];
            object[@"groupIds"] = groups;
            [object saveInBackground];
            [myTableView reloadData];
        }
        else
            NSLog(@"Error querying Parse!");
    }];
    groupName.text = @"";
}


@end
