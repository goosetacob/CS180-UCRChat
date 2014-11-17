//
//  UITableViewController+PostViewController.m
//  UCRChat
//
//  Created by user24887 on 11/16/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//
#import "PostViewController.h"
#import "TimelineController.h"

@interface PostViewController ()

@end

@implementation PostViewController
@synthesize PostControllerPIC, PostControllerName, PostControllerPost, PARENT_NAME, PARENT_POST;

- (void)viewDidLoad {
    [super viewDidLoad];
    PostControllerName.text = PARENT_NAME;
    PostControllerPost.text = PARENT_POST;
    
    NSLog(PostControllerPost.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PostBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {

    [PostControllerPIC release];
    [PostControllerName release];
    [PostControllerPost release];
    [super dealloc];
}

@end
