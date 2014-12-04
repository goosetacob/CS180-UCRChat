//
//  ViewController.h
//  UCR-Chat
//
//  Created by Gustavo Blanco on 11/24/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BORChat/BORChatRoom.h>
#import <Parse/Parse.h>


@interface ChatController : BORChatRoom

@property(nonatomic) NSString *chattingWith;

@end

