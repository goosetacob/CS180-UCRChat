//
//  UITableViewCell+CustomCell2.m
//  UCRChat
//
//  Created by user24887 on 11/23/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "CustomCell2.h"

@implementation CustomCell2


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
    [_Date release];
    [super dealloc];
}
- (IBAction)LikeCick:(id)sender {
}

- (IBAction)DislikeClick:(id)sender {
}

- (IBAction)DeleteClick:(id)sender {
}
@end
