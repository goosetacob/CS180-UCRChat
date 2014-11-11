//
//  UIViewController+NameInputController.m
//  UCRChat
//
//  Created by user25108 on 11/10/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "NameInputController.h"

@interface NameInputController()
@end

@implementation NameInputController

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
}

- (IBAction)backToUserFileController:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userNameInput:(UITextField *)sender {
    
}

@end
