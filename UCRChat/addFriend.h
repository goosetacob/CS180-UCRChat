//
//  addFriend.h
//  UCRChat
//
//  Created by user26338 on 11/18/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface addFriend : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *addFriendsArray;
    PFObject *selectedFriend;
}


@property (retain, nonatomic) IBOutlet UITableView *addFriendTableView;

@end
