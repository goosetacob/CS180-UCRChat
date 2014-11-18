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
    NSArray *Images;
    NSArray *userArray;
    NSArray *Title;
    NSArray *Description;
    NSMutableArray *allObjects;
    NSMutableArray *Friends;
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction) addFriend;


@end
