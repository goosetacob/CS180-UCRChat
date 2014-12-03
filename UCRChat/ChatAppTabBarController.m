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
    
    //create Friends on ParseDB
    PFObject *currentUserTimeline = [PFObject objectWithClassName:@"GlobalTimeline"];
    currentUserTimeline[@"userLoginId"] = [[PFUser currentUser] objectId];
    
    [currentUserTimeline saveInBackground];
    
    //Fernando
    image = [UIImage imageNamed:@"test"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    //UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    //[imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [image drawInRect: CGRectMake(0, 0, 640, 640)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (imageView.image) {
        NSData *imageAsset = UIImagePNGRepresentation(imageView.image);
        PFFile *defaultImage = [PFFile fileWithName:@"testing.png" data:imageAsset];
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Uploading";
        [HUD show:YES];
        
        // Save PFFile
        [defaultImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                PFObject *userPhoto = [PFUser currentUser];
                userPhoto[@"picture"] = defaultImage;
                [userPhoto saveInBackground];
                [userPhoto setObject:defaultImage forKey:@"picture"];
                NSLog(@"Saved image I think");
                [HUD hide:YES];
                
            }
            else{
                [HUD hide:YES];
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    else{
         NSLog(@"Shit went down");
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
