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

@property (retain, nonatomic) IBOutlet UILabel *NAME;
@property (retain, nonatomic) IBOutlet UILabel *POST;
@property (retain, nonatomic) IBOutlet UIImageView *IMG;
- (IBAction)Like:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *LikeText;

@end
