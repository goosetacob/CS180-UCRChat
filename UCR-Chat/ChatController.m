//
//  ViewController.m
//  UCR-Chat
//
//  Created by Gustavo Blanco on 11/24/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "ChatController.h"
#import "BORChatMessage.h"
#import "BORChatCollectionViewController.h"

@interface ChatController ()

@end

@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup user info
    messagesInfo = [PFQuery getObjectOfClass:@"messageThreads" objectId:_chattingWith];
    //get time we opened the APP
    chatViewStarted = [NSDate date];
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
            //get the users name
            PFObject *tempCurrentMessageUser = [PFQuery getObjectOfClass:@"_User" objectId:currentMessageUsers[j]];
            //append the new name to the end of the messageLabel
            [messageLabel appendString:tempCurrentMessageUser[@"fullName"]];
            if(j != currentMessageUsers.count-1) {
                [messageLabel appendString:@" & "];
            }
        }
    }
    self.title = messageLabel;
    
    //load existing messages
    [self loadPreExisting];
    
    
    //add button to remove people is there are MORE than 2 people in converstaion
    if (currentMessageUsers.count > 2) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(removeFriendsInMessage)];
    }
    
    //load all new messages friend sent WHILE in chat window
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkFriendMessages) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMessage {
    if (self.messageTextView.text != nil) {
        //create message for App
        id <BORChatMessage> message = [[BORChatMessage alloc] init];
        message.text = self.messageTextView.text;
        message.sentByCurrentUser = YES;
        message.date = [NSDate date];
        
        //update current messageThread in Parse
        [messagesInfo[@"messagesUser"] addObject:[[PFUser currentUser] objectId]];
        [messagesInfo[@"messagesText"] addObject:self.messageTextView.text];
        [messagesInfo[@"messagesTime"] addObject:[NSDate date]];
        [messagesInfo save];
        
        [self addMessage:message scrollToMessage:YES];
        [super sendMessage];
    }
}

-(void) loadPreExisting {
    //prase through ALL messages
    NSMutableArray *participants = [[NSMutableArray alloc] init];
    NSMutableArray *toGetUsers = [[NSMutableArray alloc] init];
    NSMutableArray *toGetText = [[NSMutableArray alloc] init];
    NSMutableArray *toGetTime = [[NSMutableArray alloc] init];
    
    participants = messagesInfo[@"inChat"];
    toGetUsers = messagesInfo[@"messagesUser"];
    toGetText = messagesInfo[@"messagesText"];
    toGetTime = messagesInfo[@"messagesTime"];
    
    for(int i = 0; i < toGetUsers.count; i++) {
        id <BORChatMessage> message = [[BORChatMessage alloc] init];
        
        if (participants.count > 2) {
            //there are more that 2 people in this message
            if ([[[PFUser currentUser] objectId] isEqualToString:toGetUsers[i]]) {
                message.sentByCurrentUser = YES;
                message.text = toGetText[i];
            } else {
                message.sentByCurrentUser = NO;
                
                PFObject *getName = [PFQuery getObjectOfClass:@"_User" objectId:toGetUsers[i]];
                NSMutableString *tempMessage = [[NSMutableString alloc] initWithString:getName[@"fullName"]];
                [tempMessage appendString:@": "];
                [tempMessage appendString:toGetText[i]];
                message.text = tempMessage;
            }
        } else {
            //there are 2 people in this message
            message.sentByCurrentUser = ([[[PFUser currentUser] objectId] isEqualToString:toGetUsers[i]] ? YES : NO);
            message.text = toGetText[i];
        }
        
        message.date = toGetTime[i];
        
        [self addMessage:message scrollToMessage:YES];
    }
}

-(void) checkFriendMessages {
    //is the messagesThread was updated AFTER the user opened this window, there are NEW messages
    
    //UPDATE
    messagesInfo = [PFQuery getObjectOfClass:@"messageThreads" objectId:_chattingWith];
    
    //allocate arrays to store new message info
    NSMutableArray *newMessageUsers = [[NSMutableArray alloc] initWithObjects:nil];
    NSMutableArray *newMessageText = [[NSMutableArray alloc] initWithObjects:nil];
    NSMutableArray *newMessageTime = [[NSMutableArray alloc] initWithObjects:nil];
    
    //get time of the NEWEST message in the messageThread
    NSArray *timeOfMessages = [[NSMutableArray alloc] init];
    timeOfMessages = messagesInfo[@"messagesTime"];
    
    
    
    //parse through all of the messages in reverse order checking if they were posted AFTER the user opened this window
    for ( int i = (int)(timeOfMessages.count-1); i >= 0; i--) {
        NSDate *lastUpdatedAt = timeOfMessages[i];
        
        //check if NEWEST message in messageThread was added AFTER this window was opened
        if ([lastUpdatedAt compare:chatViewStarted] == NSOrderedDescending) {
            //only record the message if somone other than the currentUser posted it
            if(![messagesInfo[@"messagesUser"][i] isEqualToString:[[PFUser currentUser] objectId]]) {
                //there is a NEW message to show
                //store the message,user,and time of each new message
                [newMessageUsers addObject:messagesInfo[@"messagesUser"][i]];
                [newMessageText addObject:messagesInfo[@"messagesText"][i]];
                [newMessageTime addObject:messagesInfo[@"messagesTime"][i]];
            }
        } else if ([lastUpdatedAt compare:chatViewStarted] == NSOrderedAscending) {
            //there is NO new message
        } else {
            //now sure? dates are the same?
        }
    }
    
    
    
    //display all of the new messages found!
    for(int i = (int)(newMessageText.count-1); i >= 0; i--) {
        //init new message
        id <BORChatMessage> message = [[BORChatMessage alloc] init];

        //this is a friends message
        message.sentByCurrentUser = NO;
        
        //generrate message text in following format "name: message"
        PFObject *getName = [PFQuery getObjectOfClass:@"_User" objectId:newMessageUsers[i]];
        NSMutableString *tempMessage = [[NSMutableString alloc] initWithString:getName[@"fullName"]];
        [tempMessage appendString:@": "];
        [tempMessage appendString:newMessageText[i]];
        message.text = tempMessage;

        
        message.date = newMessageTime[i];
        //update time to the LATEST time if we found new messages
        chatViewStarted = newMessageTime[i];
        [self addMessage:message scrollToMessage:YES];
    }
}

-(void)removeFriendsInMessage {
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    
    //get all of the users chat available friends
    //PFObject *userFriends = [PFQuery getObjectOfClass:@"Friends" objectId:currentUserData[@"friendClassId"]];
    NSMutableArray *friendsInMessage = [[NSMutableArray alloc] init];
    friendsInMessage = messagesInfo[@"inChat"];
    //create array with all of the users friends real names
    NSMutableArray *userFriendsNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < friendsInMessage.count; i++) {
        PFObject *userFriendInfo = [PFQuery getObjectOfClass:@"_User" objectId:friendsInMessage[i]];
        [userFriendsNames addObject:userFriendInfo[@"fullName"]];
    }
    
    vc.items = userFriendsNames;
    vc.multiSelection = YES;
    vc.allowEmpty = NO;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        chatMembersToRemove = selectedIndexPaths;
    }];
    
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(updateFriendsInMessage)];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) updateFriendsInMessage {
    NSLog(@"BEFORE %@", messagesInfo[@"inChat"]);
    for(int i = 0; i < chatMembersToRemove.count; i++) {
        NSIndexPath *current = chatMembersToRemove[i];
        [messagesInfo[@"inChat"] removeObjectAtIndex:(int)current.row];
    }
    NSLog(@"AFTER %@", messagesInfo[@"inChat"]);
    
    //save change up to parse
    [messagesInfo save];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
