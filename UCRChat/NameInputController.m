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
@synthesize currentUserId = _currentUserId;

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    _currentUserId = [[PFUser currentUser] objectId];
    
    PFObject *gameScore = [PFObject objectWithClassName:@"_User"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:_currentUserId block:^(PFObject *gameScore, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        
        gameScore[@"aboutMe"] = @"Hector Es Puto";
        NSString *playerName = gameScore[@"fullName"];
        self.textView.text = playerName;
        [gameScore saveInBackground];
        
        NSLog(@"%@", gameScore);
    }];
    
    
}

- (IBAction)backToUserFileController:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)saveReturnToUserFileController:(UIBarButtonItem *)sender{
    
    PFObject *gameScore = [PFObject objectWithClassName:@"_User"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:_currentUserId block:^(PFObject *gameScore, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        
        NSString *playerName = gameScore[@"fullName"];
        if (![self.textView.text isEqualToString:playerName]){
            
            gameScore[@"fullName"] = self.textView.text;
            [gameScore saveInBackground];
        }
       
       
        NSLog(@"%@", gameScore);
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//- (IBAction)userNameInput:(UITextField *)sender {
    
    
//}

@end
