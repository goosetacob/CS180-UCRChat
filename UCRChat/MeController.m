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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tabBarController.selectedIndex = 4;
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