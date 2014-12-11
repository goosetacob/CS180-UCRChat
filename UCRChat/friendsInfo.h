//
//  friendsInfo.h
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFriends.h"

@interface friendsInfo : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *friend_data;
    NSMutableArray *friends_array;
    
    NSMutableArray *current_groups_array;
    NSMutableArray *groups_array;
    NSInteger selected_group_row;
    
}
@property (strong, nonatomic) IBOutlet UILabel *friendTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *friendThumbImage;
@property (retain, nonatomic) IBOutlet UILabel *friendJoinedDate;
@property (retain, nonatomic) IBOutlet UILabel *friendNumberOfFriends;

@property (retain, nonatomic) IBOutlet UIPickerView *selectedGroup;
@property (retain, nonatomic) IBOutlet UILabel *friendGroups;
- (IBAction)addFriendToGroup:(id)sender;
- (IBAction)removeFriendFromGroups:(id)sender;

- (void) setMyObjectHere:(const NSString*)friend_info andArray: (const NSMutableArray*) arr withGroups: (const NSMutableArray*) Groups;
@end
