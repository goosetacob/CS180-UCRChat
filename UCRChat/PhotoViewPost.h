//
//  UIViewController+PhotoViewPost.h
//  UCRChat
//
//  Created by user24887 on 11/26/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PhotoViewPost : UIViewController
- (IBAction)Back:(id)sender;
- (IBAction)Liketbtn:(id)sender;
- (IBAction)Commentbtn:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *ProfilePicture;
@property (retain, nonatomic) IBOutlet UIImageView *Post;
@property (retain, nonatomic) IBOutlet UIButton *CommentButton;
@property (retain, nonatomic) IBOutlet UIButton *LikeButton;
@property (retain, nonatomic) IBOutlet UILabel *CommentText;
@property (retain, nonatomic) IBOutlet UILabel *LikeText;
@property (retain, nonatomic) IBOutlet UILabel *Name;

//Segue variables
@property (strong, nonatomic) NSString *PARENT_NAME;
@property (strong, nonatomic) UIImage  *PARENT_POST;
@property (strong, nonatomic) UIImage  *POST;
@property (retain, nonatomic) NSURL *VideoURL;
@property (strong, nonatomic) PFObject *UserObject;
@property (strong, nonatomic) UIImage  *Picture;

//Commenting purposes
@property (strong, nonatomic) NSString *CurrentUserNAME;
@property (strong, nonatomic) UIImage  *CurrentUserImage;
@property (strong, nonatomic) PFObject  *CurrentObject;;

@end
