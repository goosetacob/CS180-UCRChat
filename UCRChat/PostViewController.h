//
//  UITableViewController+PostViewController.h
//  UCRChat
//
//  Created by user24887 on 11/16/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PostComment.h"

@interface PostViewController : UIViewController
{
    NSMutableArray* Parray;
    NSArray* userarray;
}

@property (retain, nonatomic) IBOutlet PFImageView *PostControllerPIC;
@property (retain, nonatomic) IBOutlet UILabel *PostControllerName;
@property (retain, nonatomic) IBOutlet UILabel *PostControllerPost;

@property (strong, nonatomic) NSString *PARENT_NAME;
@property (strong, nonatomic) NSString *PARENT_POST;
@property (strong, nonatomic) NSString *ObjectID;
@property (strong, nonatomic) PFObject *UserObject;
@property (strong, nonatomic) UIImage  *ProfilePicture;

//Commenting purposes
@property (strong, nonatomic) NSString *CurrentUserNAME;
@property (strong, nonatomic) UIImage  *CurrentUserImage;
@property (strong, nonatomic) PFObject  *CurrentObject;;


@property (retain, nonatomic) IBOutlet UILabel *CommentLabel;
@property (retain, nonatomic) IBOutlet UILabel *LikeLabel;
- (IBAction)Lbtn:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *LikeButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *Loading;


//TableView information
@property (retain, nonatomic) IBOutlet UITableView *CommentView;


@end
