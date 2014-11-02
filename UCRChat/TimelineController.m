//
//  TimelineController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "TimelineController.h"
#import <Parse/Parse.h>

@interface TimelineController ()

@end

@implementation TimelineController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //storng objcts to cloud
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddPost:(id)sender {
    PFObject *User =  [PFObject objectWithClassName:@"User"];
    User[@"Username"] = @"FERNANDO";
    [User saveInBackground];
}
@end