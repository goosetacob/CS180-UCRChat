//
//  aboutMeController.h
//  UCRChat
//
//  Created by user25108 on 11/12/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//
//Test

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface aboutMeController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString *currentUserId;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@end
