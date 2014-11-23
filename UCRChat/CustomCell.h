//
//  UITableViewCell+CustomCell.h
//  UCRChat
//
//  Created by user24887 on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>



@interface  CustomCell: UITableViewCell
{
    NSArray *tempArray;
}
@property bool NewUser;
@property (retain, nonatomic) IBOutlet UILabel *NAME;
@property (retain, nonatomic) IBOutlet UILabel *LikeText;
@property (retain, nonatomic) IBOutlet PFImageView *IMG;
@property (retain, nonatomic) IBOutlet UIButton *Likebtn;
@property (retain, nonatomic) IBOutlet UILabel *POST;
@property (retain, nonatomic) IBOutlet UIButton *Delete;
@property (retain, nonatomic) IBOutlet UIView *ColorView;
@property (retain, nonatomic) IBOutlet UILabel *Date;
@property (retain, nonatomic) IBOutlet UIButton *Dislikebtn;
@property (retain, nonatomic) IBOutlet UILabel *DislikeText;

@end
