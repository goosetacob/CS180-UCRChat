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

-(id) initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if(self) {
        
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(retreiveFriendsFromPrase) forControlEvents:UIControlEventValueChanged];
    

    
    /*
    _friendsArray = [[NSArray alloc] initWithObjects:@"Gustavo",
                      @"Fernando",
                      @"Sergio",
                      @"Hector",
                      @"Gustavo",
                      @"Fernando",
                      @"Sergio",
                      @"Hector",
                      @"Gustavo",
                      @"Fernando",
                      @"Sergio",
                      @"Hector",
                      @"Gustavo",
                      @"Fernando",
                      @"Sergio",
                      @"Hector",nil];
     */
     
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChatCellController";
    ChatCellController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int row = [indexPath row];
    
   
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    [cell.friendName setTitle:[_friendsArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    NSLog(@"%d %@",row, _friendsArray[row]);
    
    return cell;
}

-(void) retreiveFriendsFromPrase{
    //find friends on Parse
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *userInfo, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        //_friendsArray = userInfo[@"Friends"];
        if (!error) {
            _friendsArray = [[NSArray alloc] initWithObjects:userInfo[@"Friends"],nil];
            NSLog(@"%@", _friendsArray);
        }
        
        [_friendsArray reloadData];
        [_refreshControl endRefreshing];
    }];

}


@end
