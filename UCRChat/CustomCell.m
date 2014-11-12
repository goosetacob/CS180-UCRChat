//
//  UITableViewCell+CustomCell.m
//  UCRChat
//
//  Created by user24887 on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "CustomCell.h"
@implementation CustomCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){};
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_NAME release];
    [_POST release];
    [_IMG release];
    [_IMG release];
    [_IMG release];
    [_LikeText release];
    [_Likebtn release];
    [super dealloc];
}
   

@end
