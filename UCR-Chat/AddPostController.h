//
//  UITableViewController+AddPostController.h
//  UCRChat
//
//  Created by user24887 on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CommentPost.h"

@interface AddPostController : UIViewController
{
    NSMutableArray* PostArray;
    PFObject *GlobalTimeline;
}
@property (retain, nonatomic) IBOutlet UIButton *VisiblityBTN;
@property (retain, nonatomic) IBOutlet UIButton *DonePost;
- (IBAction)BtnPressed:(id)sender;
- (IBAction)Cancel:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *Textview;

@property(retain, nonatomic) NSString* Identifier;
@property(retain, nonatomic) NSString* UserID;
@property (strong, nonatomic) NSString *CurrentUserNAME;
@property (strong, nonatomic) UIImage  *CurrentUserImage;
@property (strong, nonatomic) PFObject  *CurrentObject;

//Visibility array
extern NSArray* VFriends;

@end
