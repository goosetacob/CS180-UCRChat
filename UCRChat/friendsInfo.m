//
//  friendsInfo.m
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "friendsInfo.h"
#import <Parse/Parse.h>

@interface friendsInfo ()

@end

@implementation friendsInfo


@synthesize friendTitleLabel;
@synthesize friendDescriptionLabel;
@synthesize friendThumbImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToMyFriends:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    self.friendTitleLabel.text = [(id)friend_data objectForKey:@"fullName" ];
    self.friendDescriptionLabel.text = [(id)friend_data objectForKey:@"aboutMe" ];
    
    //self.friendTitleLabel.text = [(id)friend_data objectForKey:@"fullName" ];
}
// We will use this method to receive data from the main 'Friends' tab.
- (void)setMyObjectHere:(id)data
{
    friend_data = data;
    
    
    //NSLog( @"friendsInfo/setMyObjectHere: %@", [data  objectForKey:@"fullName" ]);
    //NSLog( @"friendsInfo/setMyObjectHere: %@", [data  objectForKey:@"aboutMe" ]);
    //NSLog( @"friendsInfo/setMyObjectHere: %@", [data  objectForKey:@"fullName" ]);

    friendTitleLabel.text = [data  objectForKey:@"fullName" ];
    friendDescriptionLabel.text = [data  objectForKey:@"aboutMe" ];
    
    // Query objectID to grab Friends array
    /*PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:data block:^(PFObject *object, NSError *error)
     {
         if (!error) {
             NSLog( @"Found friend: %@", object[@"fullName"]);
         }
         else
             NSLog ( @"friendsInfo/setMyObjectHere: Failed to query User!\n");
         
     }];*/
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
