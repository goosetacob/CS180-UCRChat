//
//  ChatViewController.h
//  UCRChat
//
//  Created by Gustavo Blanco on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatController.h"
#import <BWSelectViewController/BWSelectViewController.h>
#import <Parse/Parse.h>

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *labelName;
    NSMutableArray *messageObjectId;
    NSMutableArray *newChatMembers;
    PFObject *currentUserData;
    PFObject *currentUserMessages;
    PFObject *currentUserFriends;
@public
    
}

@property (retain, nonatomic) IBOutlet UITableView *friendsTable;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
