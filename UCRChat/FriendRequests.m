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


// We will use this method to receive data from the main 'Friends' tab.
- (void)setMyObjectHere:(NSString *)data
{
    
    // Query objectID to grab Friends array
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
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
         
     }];
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
