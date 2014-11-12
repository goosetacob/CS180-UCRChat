//
//  aboutMeController.m
//  UCRChat
//
//  Created by user25108 on 11/12/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "aboutMeController.h"

@implementation aboutMeController
@synthesize currentUserId = _currentUserId;

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    _currentUserId = [[PFUser currentUser] objectId];
    
    PFObject *userPointer = [PFObject objectWithClassName:@"_User"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:_currentUserId block:^(PFObject *userPointer, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        
        NSString *playerName = userPointer[@"aboutMe"];
        self.textView.text = playerName;
        
        
        NSLog(@"%@", userPointer);
    }];
}
-(IBAction)cancelToMeController:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveAboutMe:(UIBarButtonItem *)sender
{
    PFObject *userPointer = [PFObject objectWithClassName:@"_User"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:_currentUserId block:^(PFObject *userPointer, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        
        NSString *playerName = userPointer[@"fullName"];
        if (![self.textView.text isEqualToString:playerName]){
            
            userPointer[@"aboutMe"] = self.textView.text;
            [userPointer saveInBackground];
        }
        
        
        NSLog(@"%@", userPointer);
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


