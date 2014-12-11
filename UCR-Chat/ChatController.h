////
//  ViewController.h
//  UCR-Chat
//
//  Created by Gustavo Blanco on 11/24/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BORChat/BORChatRoom.h>
#import <BWSelectViewController/BWSelectViewController.h>
#import <Parse/Parse.h>


@interface ChatController : BORChatRoom {
    NSDate *chatViewStarted;
    PFObject *messagesInfo;
    NSMutableArray *chatMembersToRemove;
}

@property(nonatomic) NSString *chattingWith;

@end

