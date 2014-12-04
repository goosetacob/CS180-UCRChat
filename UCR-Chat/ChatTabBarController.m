//
//  ChatTabBarControllerViewController.m
//  UCR-Chat
//
//  Created by Gustavo Blanco on 11/30/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "ChatTabBarController.h"

@interface ChatTabBarController ()

@end

@implementation ChatTabBarController : UITabBarController

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
    //[PFUser logOut];
    
    if (![PFUser currentUser]) {
        //init login view
        PFLogInViewController *login = [[PFLogInViewController alloc] init];
        login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
        login.delegate = self;
        
        //init sign up view
        PFSignUpViewController *signUp = [[PFSignUpViewController alloc] init];
        signUp.fields =  PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsEmail | PFSignUpFieldsAdditional |PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;
        [signUp.signUpView.additionalField setPlaceholder:@"Phone number"];
        signUp.delegate = self;
        
        
        
        //make sure out login calls our signup view
        [login setSignUpController:signUp];
        
        [self presentViewController:login animated:YES completion:nil];
        //[login release];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //save all Profile, Friends, & Timeline objectIds
    PFObject *userInfo = [PFQuery getObjectOfClass:@"_User" objectId:[[PFUser currentUser] objectId]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];
    [userInfo setObject:array forKey:@"Messages"];
    [userInfo setObject:array forKey:@"Friends"];
    [userInfo save];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
