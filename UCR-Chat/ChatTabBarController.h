//
//  ChatTabBarControllerViewController.h
//  UCR-Chat
//
//  Created by Gustavo Blanco on 11/30/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ChatTabBarController : UITabBarController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end
