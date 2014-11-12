//
//  ChatViewController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCellController.h"
#import <Parse/Parse.h>

@interface ChatViewController()

@end

@implementation ChatViewController
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
    
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getLatest) userInfo:nil repeats:YES];
    
}

-(void)getLatest {
    //find friends on Parse
    PFObject *userInfo = [PFQuery getObjectOfClass:@"_User" objectId:[[PFUser currentUser] objectId]];
    friends = [[NSMutableArray alloc] initWithObjects:[userInfo objectForKey:@"Friends"], nil];
    friends = friends[0];
    
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
    NSLog(@"num friends %lu", (unsigned long)friends.count);
    return friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"friendCell";
    ChatCellController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ChatCellController alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSLog(@"%lu :: %@",(unsigned long)friends.count, friends);
    
    [cell.friendName setTitle:[friends objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    return cell;
}

-(void) dealloc {
    [friendsTable release];
    [super dealloc];
}


@end
