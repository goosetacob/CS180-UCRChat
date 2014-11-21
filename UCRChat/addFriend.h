//
//  addFriend.h
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TableCell.h"


@interface addFriend : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *addFriendsArray;
    NSArray *friends;
}

- (void) setMyObjectHere:(NSArray*)friend_list;

@property (retain, nonatomic) IBOutlet UITableView *addFriendTableView;

@end
