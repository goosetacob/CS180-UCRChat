//
//  MyFriends.h
//  UCRChat
//
//  Created by user26338 on 11/12/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TableCell.h"

@interface MyFriends : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    // Contains friends to list in TableView
    NSMutableArray *Friends;
    
    // Contains currently selected friend
    NSString *selectedFriend;
}


@property (nonatomic) BOOL *reload_friends;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;



@end
