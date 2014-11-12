//
//  UITableViewController+AddPostController.h
//  UCRChat
//
//  Created by user24887 on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddPostController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *DonePost;
- (IBAction)BtnPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *Textview;

@end
