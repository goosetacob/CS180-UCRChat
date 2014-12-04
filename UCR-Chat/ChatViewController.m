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
    labelName = [[NSMutableArray alloc] init];
    
    //create a Prase object with all of the Users Info
    PFObject *userInfo = [PFQuery getObjectOfClass:@"_User" objectId:[[PFUser currentUser] objectId]];
    PFObject *userMessageInfo = [PFQuery getObjectOfClass:@"Messages" objectId:userInfo[@"messageClassId"]];
    //array of Messages the current user is involved in
    messageObjectId = userMessageInfo[@"messageIds"];
    
    //parse through all of the messageThreads the user is involved in
    for(int i = 0; i < messageObjectId.count; i++) {
        PFObject *messagesInfo = [PFQuery getObjectOfClass:@"messageThreads" objectId:messageObjectId[i]];
        
        //array of all users in current message thread
        NSMutableArray *currentMessageUsers = [[NSMutableArray alloc] init];
        currentMessageUsers = messagesInfo[@"inChat"];
        
        //createa string with all users involved in message
        //except current user
        NSMutableString *messageLabel = [[NSMutableString alloc] initWithString:@""];
        
        //prase through all users in current message
        for (int j = 0; j < currentMessageUsers.count; j++) {
            //only append name if it's now currentUsers Name
            if (![[[PFUser currentUser] objectId] isEqualToString:currentMessageUsers[j]]) {
                NSLog(@" %@", currentMessageUsers[j]);
                NSLog(@" %@", [[PFUser currentUser] objectId]);
                //get the users name
                PFObject *tempCurrentMessageUser = [PFQuery getObjectOfClass:@"_User" objectId:currentMessageUsers[j]];
            
                //append the new name to the end of the messageLabel
                [messageLabel appendString:tempCurrentMessageUser[@"fullName"]];
                if(j != currentMessageUsers.count-1) {
                    [messageLabel appendString:@" & "];
                }
            }
        }
        
        NSLog(@" messageLabel %@", messageLabel);
    
        [labelName addObject:messageLabel];
    }
    
    NSLog(@" messageObjectId %@", messageObjectId);
    NSLog(@" labelName %@", labelName);
    
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
    //NSLog(@"num friends %lu", (unsigned long)friendsObjectId.count);
    return messageObjectId.count;
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
    
    NSLog(@"%lu :: %@",(unsigned long)labelName.count, labelName);
    
    
    [cell.friendName setTitle:[labelName objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender{
    if([segue.identifier isEqualToString:@"talkToFriend"]){
        //find the ObjId of the matching converstaion
        int index = 0;
        
        //create a Prase object with all of the Users Info
        PFObject *userInfo = [PFQuery getObjectOfClass:@"_User" objectId:[[PFUser currentUser] objectId]];
        PFObject *userMessageInfo = [PFQuery getObjectOfClass:@"Messages" objectId:userInfo[@"messageClassId"]];
        //array of Messages the current user is involved in
        messageObjectId = userMessageInfo[@"messageIds"];
        //parse through all of the messageThreads the user is involved in
        for(; index < messageObjectId.count; index++) {
            PFObject *messagesInfo = [PFQuery getObjectOfClass:@"messageThreads" objectId:messageObjectId[index]];
            //array of all users in current message thread
            NSMutableArray *currentMessageUsers = [[NSMutableArray alloc] init];
            currentMessageUsers = messagesInfo[@"inChat"];
            //createa string with all users involved in message
            //except current user
            NSMutableString *messageLabel = [[NSMutableString alloc] initWithString:@""];
            //prase through all users in current message
            for (int j = 0; j < currentMessageUsers.count; j++) {
                //only append name if it's now currentUsers Name
                if (![[[PFUser currentUser] objectId] isEqualToString:currentMessageUsers[j]]) {
                    NSLog(@" %@", currentMessageUsers[j]);
                    NSLog(@" %@", [[PFUser currentUser] objectId]);
                    //get the users name
                    PFObject *tempCurrentMessageUser = [PFQuery getObjectOfClass:@"_User" objectId:currentMessageUsers[j]];
                    //append the new name to the end of the messageLabel
                    [messageLabel appendString:tempCurrentMessageUser[@"fullName"]];
                    if(j != currentMessageUsers.count-1) {
                        [messageLabel appendString:@" & "];
                    }
                }
            }
            if ([messageLabel isEqualToString:sender.currentTitle]) {
                break;
            }
        }
        
        ChatController *controller = (ChatController *)segue.destinationViewController;
        controller.chattingWith = messageObjectId[index];
    }
}

- (IBAction)createNewChat:(UIBarButtonItem *)sender {
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    
    //get all of the current users information
    PFObject *user = [PFQuery getObjectOfClass:@"_User" objectId:[[PFUser currentUser] objectId]];
    //get all of the users chat available friends
    PFObject *userFriends = [PFQuery getObjectOfClass:@"Friends" objectId:user[@"friendClassId"]];
    NSMutableArray *userFriendsObjectId = [[NSMutableArray alloc] init];
    userFriendsObjectId = userFriends[@"Friends"];
    //create array with all of the users friends real names
    NSMutableArray *userFriendsNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < userFriendsObjectId.count; i++) {
        PFObject *userFriendInfo = [PFQuery getObjectOfClass:@"_User" objectId:userFriendsObjectId[i]];
        [userFriendsNames addObject:userFriendInfo[@"fullName"]];
    }
    
    vc.items = userFriendsNames;
    vc.multiSelection = YES;
    vc.allowEmpty = NO;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        newChatMembers = selectedIndexPaths;
        NSLog(@"newChatMembers %@", newChatMembers);
    }];
    
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createChat)];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) createChat {
    //get list of friends the user picked from
    PFObject *user = [PFQuery getObjectOfClass:@"_User" objectId:[[PFUser currentUser] objectId]];
    PFObject *userFriends = [PFQuery getObjectOfClass:@"Friends" objectId:user[@"friendClassId"]];
    NSMutableArray *userFriendsObjectId = [[NSMutableArray alloc] init];
    userFriendsObjectId = userFriends[@"Friends"];
    
    //create array of friends the user chose
    NSMutableArray *chosenFriendsObjectId = [[NSMutableArray alloc] init];
    for (int i = 0; i < newChatMembers.count; i++) {
        NSIndexPath *current = [[NSIndexPath alloc] init];
        current = newChatMembers[i];
        [chosenFriendsObjectId addObject:userFriendsObjectId[(int)current.row]];
    }
    [chosenFriendsObjectId addObject:[[PFUser currentUser] objectId]];
    
    //create new Prase messageThread object with friends in new thread and save
    PFObject *newMessageThread = [PFObject objectWithClassName:@"messageThreads"];
    NSMutableArray *empty = [[NSMutableArray alloc] initWithObjects: nil];
    newMessageThread[@"inChat"] = chosenFriendsObjectId;
    newMessageThread[@"messagesUser"] = empty;
    newMessageThread[@"messagesText"] = empty;
    newMessageThread[@"messagesTime"] = empty;
    [newMessageThread save];
    
    //save message to current users list of messages
    PFObject *toUpdateUser = [PFQuery getObjectOfClass:@"_User" objectId:[[PFUser currentUser] objectId]];
    PFObject *toUpdateFriends = [PFQuery getObjectOfClass:@"Messages" objectId:toUpdateUser[@"messageClassId"]];;
    [toUpdateFriends[@"messageIds"] addObject:[newMessageThread objectId]];
    [toUpdateFriends save];
    
    //save to all involved users list of message
    for (int i = 0; i < chosenFriendsObjectId.count; i++) {
        if (![chosenFriendsObjectId[i] isEqualToString:[[PFUser currentUser] objectId]]) {
            PFObject *chosenUserInfo = [PFQuery getObjectOfClass:@"_User" objectId:chosenFriendsObjectId[i]];
            PFObject *tempUserMessageInfo = [PFQuery getObjectOfClass:@"Messages" objectId:chosenUserInfo[@"messageClassId"]];
            [tempUserMessageInfo[@"messageIds"] addObject:[newMessageThread objectId]];
            NSLog(@" chosenUserInfo: %@", chosenUserInfo[@"messageIds"]);
            [tempUserMessageInfo saveInBackground];
        }
    }
    
    [self getLatest];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
