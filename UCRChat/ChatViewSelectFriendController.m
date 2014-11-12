//
//  ChatViewController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "ChatViewSelectFriendController.h"
#import "ChatCellSelectFriendController.h"
#import <Parse/Parse.h>

@interface ChatViewSelectFriendController()

@end

@implementation ChatViewSelectFriendController

@synthesize friendsTable;


-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self.friendsTable setDelegate:self];
    [self.friendsTable setDataSource:self];
    
    
    // Initialize the refresh control.
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor purpleColor];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self
                        action:@selector(getLatest)
              forControlEvents:UIControlEventValueChanged];
    
    [self.friendsTable addSubview:_refreshControl];
    [self.friendsTable reloadData];
    
    [self getLatest];
    
}

-(void)getLatest {
    //find friends on Parse
    PFObject *userInfo = [PFQuery getObjectOfClass:@"_User" objectId:@"messageThreads"];
    friendMessages = [[NSMutableArray alloc] initWithObjects:[userInfo objectForKey:@"Friends"], nil];
    friendMessages = friendMessages[0];
    
    [self.friendsTable reloadData];
    [_refreshControl endRefreshing];
    
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"num friends %lu", (unsigned long)friendMessages.count);
    return friendMessages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"messageCell";
    ChatCellSelectFriendController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ChatCellSelectFriendController alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSLog(@"%lu :: %@",(unsigned long)friendMessages.count, friendMessages);
    
    
    //FIREGUREOUT LATERS
    cell.name.text = @"GUCCI";
    cell.message.text = @"HelloWorld";
    return cell;
}

-(void) dealloc {
    [friendsTable release];
    [super dealloc];
}

@end
