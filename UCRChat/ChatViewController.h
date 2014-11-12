//
//  ChatViewController.h
//  UCRChat
//
//  Created by Gustavo Blanco on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UITableViewController

@property (nonatomic, strong) NSArray *friendsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
