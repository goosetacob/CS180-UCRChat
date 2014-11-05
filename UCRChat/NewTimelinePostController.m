//
//  UIViewController+NewTimelinePostController.m
//  UCRChat
//
//  Created by user25108 on 11/1/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "NewTimelinePostController.h"


@interface NewTimelinePostController ()
@property (weak, nonatomic) IBOutlet UITextField *post_text;
- (IBAction)PostButton:(id)sender;

@end

@implementation NewTimelinePostController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PostButton:(id)sender {
    PFObject *User =  [PFObjecst objectWithClassName:@"User"];
    
    User[@"Username"] = post_text.text;
    [User saveInBackground];
}
@end
