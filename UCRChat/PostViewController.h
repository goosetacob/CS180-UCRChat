//
//  UITableViewController+PostViewController.h
//  UCRChat
//
//  Created by user24887 on 11/16/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *PostControllerPIC;
@property (retain, nonatomic) IBOutlet UILabel *PostControllerName;
@property (retain, nonatomic) IBOutlet UILabel *PostControllerPost;

@property (strong, nonatomic) NSString *PARENT_NAME;
@property (strong, nonatomic) NSString *PARENT_POST;

@end
