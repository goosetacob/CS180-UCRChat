//
//  MeController.m
//  UCRChat
//
//  Created by user25108 on 11/1/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "MeController.h"

@interface MeController ()

@end

@implementation MeController
@synthesize currentUserId = _currentUserId;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBarController.selectedIndex = 4;
    
    _currentUserId = [[PFUser currentUser] objectId];
    
    PFObject *userPointer = [PFObject objectWithClassName:@"_User"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:_currentUserId block:^(PFObject *userPointer, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        
        NSString *playerName = userPointer[@"fullName"];
        NSString *blogg = userPointer[@"aboutMe"];
        [self.nameView setTitle:playerName forState:UIControlStateNormal];
        [self.labelView setText:blogg];
        
        
        NSLog(@"%@", userPointer);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOffUser {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}



@end