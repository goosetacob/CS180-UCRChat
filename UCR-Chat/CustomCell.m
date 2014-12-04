//
//  UITableViewCell+CustomCell.m
//  UCRChat
//
//  Created by user24887 on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "CustomCell.h"
@implementation CustomCell
@synthesize NewUser;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NewUser = true;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){};
    
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
   

- (IBAction)CommentBtn:(id)sender {
}
@end
