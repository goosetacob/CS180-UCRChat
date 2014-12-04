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
    PFObject *messagesInfo = [PFQuery getObjectOfClass:@"messageThreads" objectId:_chattingWith];
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
    self.title = messageLabel;
    
    //load existing messages
    [self loadPreExisting];
    
    //load all pre-existing messages
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkFriendMessages) userInfo:nil repeats:YES];
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
        PFObject *messagesInfo = [PFQuery getObjectOfClass:@"messageThreads" objectId:_chattingWith];
        [messagesInfo[@"messagesUser"] addObject:[[PFUser currentUser] objectId]];
        [messagesInfo[@"messagesText"] addObject:self.messageTextView.text];
        [messagesInfo[@"messagesTime"] addObject:[NSDate date]];
        [messagesInfo save];
        
        [self addMessage:message scrollToMessage:YES];
        [super sendMessage];
    }
}

-(void) loadPreExisting {
    PFObject *messagesInThread = [PFQuery getObjectOfClass:@"messageThreads" objectId:_chattingWith];
    //NSLog(@"%@", messagesInThread);
    
    //prase through ALL messages
    NSMutableArray *participants = [[NSMutableArray alloc] init];
    NSMutableArray *toGetUsers = [[NSMutableArray alloc] init];
    NSMutableArray *toGetText = [[NSMutableArray alloc] init];
    NSMutableArray *toGetTime = [[NSMutableArray alloc] init];
    
    participants = messagesInThread[@"inChat"];
    toGetUsers = messagesInThread[@"messagesUser"];
    toGetText = messagesInThread[@"messagesText"];
    toGetTime = messagesInThread[@"messagesTime"];
    
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

}

@end
