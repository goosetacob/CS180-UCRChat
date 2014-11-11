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
    
    
    //[PFUser logOut];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *login = [[PFLogInViewController alloc] init];
        login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
        login.delegate = self;
        login.signUpController.delegate = self;
        [self presentViewController:login animated:YES completion:nil];
        [login release];
    }
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
    
    //create Timeline on ParseDB
    PFObject *currentUserTimeline = [PFObject objectWithClassName:@"GlobalTimeline"];
    currentUserTimeline[@"userLoginId"] = [[PFUser currentUser] objectId];
    [currentUserTimeline saveInBackground];
    
    //save all Profile, Friends, & Timeline objectIds
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] username] block:^(PFObject *userInfo, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score will get sent to the cloud. playerName hasn't changed.
        userInfo[@"profileObjectId"] = currentUserInfo.objectId;
        userInfo[@"friendsObjectId"] = currentUserFriends.objectId;
        userInfo[@"timelineObjectId"] = currentUserTimeline.objectId;
        [userInfo saveInBackground];
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
