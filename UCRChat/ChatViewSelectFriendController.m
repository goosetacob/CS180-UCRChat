//
//  ChatViewController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "ChatViewSelectFriendController.h"
#import "ChatCellSelectFriendController.h"

@interface ChatViewSelectFriendController()

@end

@implementation ChatViewSelectFriendController

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
    static NSString *CellIdentifier = @"ChatCellSelectFriendController";
    ChatCellSelectFriendController *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int row = [indexPath row];
    
   
    
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell1.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell1.name.text = [_friendsArray objectAtIndex:indexPath.row];
    cell1.message.text = @"Hello World";
    NSLog(@"%d %@",row, _friendsArray[row]);
    
    return cell1;
}


@end
