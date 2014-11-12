//
//  SendMessage.h
//  UCRChat
//
//  Created by Gustavo Blanco on 11/12/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ChatViewSelectFriendController.h"

@interface SendMessage : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *DonePost;
- (IBAction)BtnPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *Textview;
@property (retain, nonatomic) NSString *currentFriend;

@end
