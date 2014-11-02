//
//  TimelineController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "NewPostController.h"
#import <Parse/Parse.h>

@interface FriendsController ()

@end

@implementation FriendsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //storng objcts to cloud
    PFObject *User =  [PFObject objectWithClassName:@"User"];
    User[@"Username"] = @"Hdomi001";
    
    //UIImage *img = [UIImage imageNamed:@"Picture"];
   // NSData *imagedata = UIImageJPEGRepresentation(<#UIImage *image#>, 50);
    //User[@"Picture"]  = imagedata;
    [User saveInBackground];
    
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end