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

@interface friendsInfo ()

@end

@implementation friendsInfo


@synthesize selectedGroup;
@synthesize friendNumberOfFriends;
@synthesize friendJoinedDate;
@synthesize friendTitleLabel;
@synthesize friendDescriptionLabel;
@synthesize friendThumbImage;

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
        if( [[(id)object objectForKey: @"username" ]  isEqualToString:[(id)friend_data objectForKey:@"username"]] )
        {
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
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    self.friendTitleLabel.text = [(id)friend_data objectForKey:@"fullName" ];
    self.friendDescriptionLabel.text = [(id)friend_data objectForKey:@"aboutMe" ];
    PFFile *imagefile = [(id)friend_data objectForKey:@"picture"];
    NSURL* imageURL = [[NSURL alloc] initWithString:imagefile.url];
    NSData* image = [NSData dataWithContentsOfURL:imageURL ];
    
    self.friendThumbImage.image = [UIImage imageWithData:image];
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:[(id)friend_data objectForKey:@"friendClassId"] block:^(PFObject *object, NSError *error) {
        if( !error )
        {
            self.friendNumberOfFriends.text = [NSString stringWithFormat: @"%ld", [(NSMutableArray*)object[@"Friends"] count]];
            self.friendJoinedDate.text = [formatter stringFromDate: object.createdAt];

            NSLog(@"%@", object.createdAt);
        }
    }];
}
// We will use this method to receive data from the main 'Friends' tab.
- (void)setMyObjectHere:(id)data andArray:(NSMutableArray *)arr withGroups:(NSMutableArray *)Groups
{
    friend_data = data;
    friends_array = arr;
    groups_array = Groups;
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;//groups_array.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"Example";
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
    [friendJoinedDate release];
    [friendNumberOfFriends release];
    [selectedGroup release];
    [super dealloc];
}
@end
