//
//  MyFriends.m
//  UCRChat
//
//  Created by user26338 on 11/12/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "MyFriends.h"
#import <Parse/Parse.h>
#import "TableCell.h"


@interface MyFriends ()

@end

@implementation MyFriends


@synthesize myTableView;


- (IBAction) addFriend
{
    //[self performSegueWithIdentifier:@"addFriends" sender:self];
    
}

// Gets a full list of Users from Parse
- (void) retrieveFromParse
{
    PFQuery *ret = [PFQuery queryWithClassName:@"_User"];
    [ret findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if( !error )
        {
            userArray = [ [NSArray alloc] initWithArray:objects ];
        }
        else
        {
            NSLog( @"ERROR querying data!");
        }
        
    }];
    
    [self.myTableView reloadData];
}

- (void) retrieveFriends
{
    // Get ObjectID of current user
    NSString *currId = [PFUser currentUser ].objectId;
    
    
    // Query objectID to grab Friends array
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:currId block:^(PFObject *object, NSError *error)
     {
         if (!error) {
             // Do something with the found friend array
             for (NSString *friend in object[@"Friends"]) {
                 // Query a second time to get one specific friend ObjectId
                 PFQuery *query2 = [PFQuery queryWithClassName:@"_User"];
                 [query2 getObjectInBackgroundWithId:friend block:^(PFObject *object, NSError *error)
                  {
                      // We've grabbed on PFObject from our array of friends. Now we parse through our Friends array
                      // and run some checks.
                      if (!error)
                      {
                          
                          NSInteger exists = 0;
                          for( PFObject* j in Friends )
                          {
                              if( j.objectId == object.objectId )
                                  exists = 1;
                          }
                          
                          // If we have a unique friend, add it to our Friend array
                          if( exists == 0 )
                          {
                              [Friends addObject:object ];
                          }
                          
                      } else {
                          // Log details of the failure
                          NSLog(@"Error: %@ %@", error, [error userInfo]);
                      }
                      
                      
                      // This is critical for making sure our cells are correctly up-to-date on screen!
                      [self.myTableView reloadData];
                  }];
                 

             }
             
             
             
         } else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set TableView delegate and data source
    [myTableView setDataSource:self];
    [myTableView setDelegate:self];
    
    // Initialize mutable arrays!
    Friends = [[NSMutableArray alloc] init];
    allObjects = [[NSMutableArray alloc] init];
    
    // Populate Friend array using current user's data
    [self retrieveFriends];
    
    //[self performSelector:@selector(retrieveFromParse)];
    // Update list of friends every minute
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(retrieveFriends) userInfo:nil repeats:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // In our Friends View Controller, the number of rows in our Table View depends on how many friends we have
    return Friends.count;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    cell.ThumbImage.image = [object objectForKey:@"picture"];
    
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

@end
