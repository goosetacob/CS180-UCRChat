//
//  ChatController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "ChatController.h"

@interface ChatController ()

@property (strong) NSString *chatLogin;
@property (strong) NSString *chatPassword;
@property (strong) QBSessionParameters *parameters;

@end

@implementation ChatController

@synthesize chatLogin = _chatLogin;
@synthesize chatPassword = _chatPassword;
@synthesize parameters = _parameters;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [QBRequest createSessionWithSuccessBlock:nil errorBlock:nil];
    
    //get info to create chat
    _chatLogin = [[PFUser currentUser] username];
    _chatPassword = [[PFUser currentUser] password];
    
    
    //set parameters for chat session
    _parameters = [QBSessionParameters new];
    _parameters.userLogin = _chatLogin;
    _parameters.userPassword = _chatPassword;
    
    [QBRequest createSessionWithExtendedParameters:_parameters successBlock:^(QBResponse *response, QBASession *session) {
        // Sign In to QuickBlox Chat
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID; // your current user's ID
        currentUser.password = _chatPassword; // your current user's password
        
        // set Chat delegate
        [QBChat instance].delegate = self;
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"error: %@", response.error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Chat delegate
-(void) chatDidLogin{
    // You have successfully signed in to QuickBlox Chat
}

- (void)chatDidNotLogin{
    
}



@end

