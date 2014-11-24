//
//  UITableViewCell+CustomCell2.h
//  UCRChat
//
//  Created by user24887 on 11/23/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface  CustomCell2: UITableViewCell


/*
@property (retain, nonatomic) IBOutlet UIImageView *PicPost;
@property (retain, nonatomic) IBOutlet UIImageView* ProfilePic;
- (IBAction)LikeClick:(id)sender;
- (IBAction)DislikeClick:(id)sender;
- (IBAction)DeleteClick:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *UserName;
@property (retain, nonatomic) IBOutlet UILabel *Date;

 */
@property (retain, nonatomic) IBOutlet UILabel *NAME;
@property (retain, nonatomic) IBOutlet UILabel *LikeText;
@property (retain, nonatomic) IBOutlet UIImageView *IMG;
@property (retain, nonatomic) IBOutlet UIButton *Likebtn;
@property (retain, nonatomic) IBOutlet UIImageView *PICPOST;
@property (retain, nonatomic) IBOutlet UIButton *Delete;
@property (retain, nonatomic) IBOutlet UIView *ColorView;
@property (retain, nonatomic) IBOutlet UILabel *Date;
@property (retain, nonatomic) IBOutlet UIButton *Dislikebtn;
@property (retain, nonatomic) IBOutlet UILabel *DislikeText;
@end