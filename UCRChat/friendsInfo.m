//
//  friendsInfo.m
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "friendsInfo.h"
#import <Parse/Parse.h>
#import "MyFriends.h"

BOOL done_loading;

@interface friendsInfo ()

@end

@implementation friendsInfo


@synthesize selectedGroup;
@synthesize friendNumberOfFriends;
@synthesize friendJoinedDate;
@synthesize friendTitleLabel;
@synthesize friendDescriptionLabel;
@synthesize friendThumbImage;
@synthesize friendGroups;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [selectedGroup setDelegate:self];
    [selectedGroup setDataSource:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToMyFriends:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)removeFriend:(UIBarButtonItem *)sender
{
    PFUser *current = [PFUser currentUser];
    for( id object in friends_array)
    {
        // Find the user to be deleted by checking usernames
        if( [[(id)object objectForKey: @"username" ]  isEqualToString:[(id)friend_data objectForKey:@"username"]] )
        {
            // Go through all groups that the user-to-be-removed-from-groups is in
            for( id group in current_groups_array )
            {
                // Get the group from Parse
                PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
                [
                 query getObjectInBackgroundWithId:[(PFObject*)group objectId] block:^(PFObject *object, NSError *error) {
                     if( !error )
                     {
                         // Update it's friendClassIdSet array by removing the objectId of the friend
                         NSMutableArray *friendSet = [[NSMutableArray alloc] initWithArray:object[@"friendClassIdSet"]];
                         for( NSString* friend_id in friendSet )
                         {
                             if( [friend_id isEqualToString:[(id)friend_data objectId]] )
                             {
                                 [friendSet removeObject:friend_id];
                                 break;
                             }
                         }
                         object[@"friendClassIdSet"] = friendSet;
                         [object saveInBackground];
                     }
                     else
                         NSLog(@"Error querying Parse!");
                 }];
            }
            // Remove current user from friend object in Parse
            PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
            [query getObjectInBackgroundWithId:[object objectForKey:@"friendClassId"] block:^(PFObject *fobject, NSError *error) {
                if( !error )
                {
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:fobject[@"Friends"]];
                    [arr removeObject:current.objectId];
                    fobject[@"Friends"] = arr;
                    
                    [fobject saveInBackground];
                }
                else
                    NSLog(@"Error querying Parse!");
            }];
            
            // Remove friend object from current user in Parse
            PFQuery *query2 = [PFQuery queryWithClassName:@"Friends"];
            [query2 getObjectInBackgroundWithId:[current objectForKey:@"friendClassId"] block:^(PFObject *fobject, NSError *error) {
                if( !error )
                {
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:fobject[@"Friends"]];
                    [arr removeObject:[object objectId]];
                    fobject[@"Friends"] = arr;
                    
                    [fobject saveInBackground];
                }
                else
                    NSLog(@"Error querying Parse!");
            }];
            
            
        }
    }
    
    done_loading = true;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    // Set Name, About Me, and Image
    self.friendTitleLabel.text = [(id)friend_data objectForKey:@"fullName" ];
    self.friendDescriptionLabel.text = [(id)friend_data objectForKey:@"aboutMe" ];
    PFFile *imagefile = [(id)friend_data objectForKey:@"picture"];
    NSURL* imageURL = [[NSURL alloc] initWithString:imagefile.url];
    NSData* image = [NSData dataWithContentsOfURL:imageURL ];
    
    self.friendThumbImage.image = [UIImage imageWithData:image];
   
    // Set date joined
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:[(id)friend_data objectForKey:@"friendClassId"] block:^(PFObject *object, NSError *error) {
        if( !error )
        {
            self.friendNumberOfFriends.text = [NSString stringWithFormat: @"%ld", [(NSMutableArray*)object[@"Friends"] count]];
            self.friendJoinedDate.text = [formatter stringFromDate: object.createdAt];
        }
        else
            NSLog(@"Error querying Parse!");
    }];
    
    // Find groups that user isn't already in
    current_groups_array = [[NSMutableArray alloc] init ];
    for( PFObject* group in groups_array )
    {
        for( NSString* friend_object_id in [group objectForKey:@"friendClassIdSet"])
        {
            
            if( [friend_object_id isEqualToString:[(PFObject*)friend_data objectId ]] )
            {
                // Place him in current groups
                [current_groups_array addObject:group];
            }
        }
    }
    
    for( PFObject *group in current_groups_array )
    {
        for( PFObject *group2 in groups_array )
        {
            if( [[group objectId] isEqualToString: [group2 objectId]])
            {
                [groups_array removeObject:group2];
                break;
            }
        }
        
    }
    NSMutableArray *cga = [[NSMutableArray alloc] init ];
    for( PFObject *i in current_groups_array )
        [cga addObject:[i objectForKey:@"groupName" ]];
    
    if( cga.count == 1)
        friendGroups.text = [cga  componentsJoinedByString:@""];
    else if( cga.count > 1)
        friendGroups.text = [cga componentsJoinedByString:@", "];
    
    // Initialize variables
    selected_group_row = 0;
    
}

// We will use this method to receive data from the main 'Friends' tab.
- (void)setMyObjectHere:(const NSString*)data andArray:(const NSMutableArray *)arr withGroups:(const NSMutableArray *)Groups
{
    friend_data = (NSString*) data;;
    friends_array = /*(NSMutableArray*) arr;*/[[NSMutableArray alloc] initWithArray:(NSMutableArray*)arr ];
    groups_array = /*(NSMutableArray*) Groups;*/[[NSMutableArray alloc] initWithArray:(NSMutableArray*)Groups ];

}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return groups_array.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selected_group_row = row;
    if( groups_array.count > 0)
        NSLog(@"You've picked %lu %@", row, [groups_array[row] objectForKey:@"groupName"]);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if( groups_array.count > 0)
        return [groups_array[row] objectForKey:@"groupName"];
    else
        return @"";
}

- (IBAction)addFriendToGroup:(id)sender {
    // If we have no groups, don't do anything
    if(groups_array == nil || groups_array.count < 1)
        return;
    
    
    // Decrement selected_group_row in the case where the app doesn't update it
    //selected_group_row = selected_group_row - 1;
    
    // Add the user to the group in Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
    //NSLog(@"%@", groups_array[selected_group_row]);
    [query getObjectInBackgroundWithId:[(PFUser *)groups_array[selected_group_row] objectId] block:^(PFObject *object, NSError *error) {
        if (!error )
        {
            NSMutableArray *friends = [[NSMutableArray alloc] initWithArray:object[@"friendClassIdSet"]];
            [friends addObject:[(id)friend_data objectId]];
            object[@"friendClassIdSet"] = friends;
            [object saveInBackground];
            
        }
        else
            NSLog(@"Error querying Parse!");
    }];

    // Remove selected group from array
    [current_groups_array addObject:groups_array[selected_group_row]];
    [groups_array removeObject:groups_array[selected_group_row]];

    // Reload group data text
    NSMutableArray *cga = [[NSMutableArray alloc] init ];
    for( PFObject *i in current_groups_array )
        [cga addObject:[i objectForKey:@"groupName"] ];
    if( cga.count == 1)
        friendGroups.text = [cga  componentsJoinedByString:@""];
    else if( cga.count > 1)
        friendGroups.text = [cga componentsJoinedByString:@", "];

    done_loading = true;
    [selectedGroup reloadAllComponents];
}

- (IBAction)removeFriendFromGroups:(id)sender
{
    // Go through all groups that the user-to-be-removed-from-groups is in
    for( id group in current_groups_array )
    {
        // Get the group from Parse
        PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
        [
         query getObjectInBackgroundWithId:[(PFObject*)group objectId] block:^(PFObject *object, NSError *error) {
            if( !error )
            {
                // Update it's friendClassIdSet array by removing the objectId of the friend
                NSMutableArray *friendSet = [[NSMutableArray alloc] initWithArray:object[@"friendClassIdSet"]];
                for( NSString* friend_id in friendSet )
                {
                    if( [friend_id isEqualToString:[(id)friend_data objectId]] )
                    {
                        [friendSet removeObject:friend_id];
                        break;
                    }
                }
                object[@"friendClassIdSet"] = friendSet;
                [object saveInBackground];
            }
            else
                NSLog(@"Error querying Parse!");
        }];
    }
    
    done_loading = true;
    [self dismissViewControllerAnimated:YES completion:nil];
}


    // Refresh picker v
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [friendJoinedDate release];
    [friendNumberOfFriends release];
    [selectedGroup release];
    [friendGroups release];
    [super dealloc];
}
@end
