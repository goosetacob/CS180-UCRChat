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
{
    NSMutableArray* Parray;
}

@property (retain, nonatomic) IBOutlet UIImageView *PostControllerPIC;
@property (retain, nonatomic) IBOutlet UILabel *PostControllerName;
@property (retain, nonatomic) IBOutlet UILabel *PostControllerPost;

@property (strong, nonatomic) NSString *PARENT_NAME;
@property (strong, nonatomic) NSString *PARENT_POST;
@property (strong, nonatomic) NSString *PARENT_LIKE;
@property (strong, nonatomic) NSString *PARENT_COMMENT;
@property (strong, nonatomic) NSString *ObjectID;


@property (retain, nonatomic) IBOutlet UILabel *CommentLabel;
@property (retain, nonatomic) IBOutlet UILabel *LikeLabel;
//- (IBAction)Cbtn:(id)sender;
- (IBAction)Lbtn:(id)sender;
//@property (retain, nonatomic) IBOutlet UIButton *CommentButton;
@property (retain, nonatomic) IBOutlet UIButton *LikeButton;

@end
