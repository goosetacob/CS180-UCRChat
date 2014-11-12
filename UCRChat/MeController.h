//
//  UIViewController+MeController.h
//  UCRChat
//
//  Created by user25108 on 11/1/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MeController : UIViewController

@property (strong, nonatomic) NSString *currentUserId;
@property (retain, nonatomic) IBOutlet UIButton *nameView;
@property (retain, nonatomic) IBOutlet UILabel *labelView;;

@end