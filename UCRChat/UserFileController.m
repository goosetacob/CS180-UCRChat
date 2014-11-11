//
//  UserFileController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 11/9/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "UserFileController.h"

@interface UserFileController () 
//- (void)actionSheet:(UIButton *)sender; //Declaration for Action Sheet
@end

@implementation UserFileController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)returnToProfile:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Photos", nil];
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}
   
@end
