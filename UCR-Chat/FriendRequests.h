//
//  FriendRequests.h
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TableCell.h"

@interface FriendRequests : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *friend_requests;
}

- (void) setMyObjectHere:(NSString*)userr_info;

@property (retain, nonatomic) IBOutlet UITableView *friendRequestsTableView;

@end
