//
//  UITabBarController+ChatAppTabBarController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 11/9/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "ChatAppTabBarController.h"

@implementation ChatAppTabBarController : UITabBarController

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    
    //s[PFUser logOut];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *login = [[PFLogInViewController alloc] init];
        login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
        login.delegate = self;
        login.signUpController.delegate = self;
        [self presentViewController:login animated:YES completion:nil];
        [login release];
    }
    
    
    /*PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject *object, NSError *error) {
        
        if( !error )
        {
            //[object addObject:@"helllo" forKey:@"fullName"];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:object[@"friendRequests"]];
            [arr addObject:@"helloooooo"];
            object[@"friendRequests"] = arr;
            [object saveInBackground];
        }
    }];*/
}

-(void) viewDidUnload {
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

-(void) logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    //create Profile on ParseDB
    PFObject *currentUserInfo = [PFObject objectWithClassName:@"Profile"];
    currentUserInfo[@"userLoginId"] = [[PFUser currentUser] objectId];
    [currentUserInfo saveInBackground];
    
    //create Friends on ParseDB
    PFObject *currentUserFriends = [PFObject objectWithClassName:@"Friends"];
    currentUserFriends[@"userLoginId"] = [[PFUser currentUser] objectId];
    [currentUserFriends saveInBackground];
    
    //create Friends on ParseDB
    PFObject *currentUserTimeline = [PFObject objectWithClassName:@"GlobalTimeline"];
    currentUserTimeline[@"userLoginId"] = [[PFUser currentUser] objectId];

    [currentUserTimeline saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
