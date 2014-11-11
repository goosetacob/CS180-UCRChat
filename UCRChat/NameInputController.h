//
//  NameInputController.h
//  UCRChat
//
//  Created by user25108 on 11/10/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NameInputController : UIViewController

@property (strong, nonatomic) NSString *name;
@property (retain, nonatomic) IBOutlet UITextField *textField;

@end

