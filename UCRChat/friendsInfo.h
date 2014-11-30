//
//  friendsInfo.h
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFriends.h"

@interface friendsInfo : UIViewController
{
    NSString *friend_data;
    NSMutableArray *friends_array;
}
@property (strong, nonatomic) IBOutlet UILabel *friendTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *friendThumbImage;

- (void) setMyObjectHere:(NSString*)friend_info andArray: (NSMutableArray*) arr;
@end
