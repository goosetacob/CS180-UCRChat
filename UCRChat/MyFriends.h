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
    NSMutableArray *images;
    
    // Contains list of Groups for separate Friends
    NSMutableArray *Groups;
    
    // Contains currently selected friend
    NSString *selectedFriend;
    
}

extern BOOL done_loading;

- (IBAction)addGroup:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *groupName;

@property (retain, nonatomic) IBOutlet UITableView *myTableView;



@end
