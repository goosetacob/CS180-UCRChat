//
//  ChatViewController.h
//  UCRChat
//
//  Created by Gustavo Blanco on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewSelectFriendController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    NSMutableArray *friendMessages;
}

@property (retain, nonatomic) IBOutlet UITableView *friendsTable;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (retain, nonatomic) IBOutlet UITextView *messageInput;
@property (retain, nonatomic) NSString *userMessaged;

@end

