//
//  NameInputController.m
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
    
    PFObject *userPointer = [PFObject objectWithClassName:@"_User"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:_currentUserId block:^(PFObject *userPointer, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        
        NSString *playerName = userPointer[@"fullName"];
        self.textView.text = playerName;

        
        NSLog(@"%@", userPointer);
    }];
}

- (IBAction)backToUserFileController:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveUserNameInput:(UIBarButtonItem *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId]
                                 block:^(PFObject *userInfo, NSError *error) {
        
        // Now let's update it with some new data.8
        userInfo[@"fullName"] = self.textField.text;
        [userInfo saveInBackground];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
}

@end
