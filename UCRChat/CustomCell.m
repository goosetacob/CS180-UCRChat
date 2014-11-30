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

- (void)dealloc {
    [_NAME release];
    [_POST release];
    [_IMG release];
    [_LikeText release];
    [_Likebtn release];
    [_Delete release];
    [_ColorView release];
    [_Date release];
    [_Dislikebtn release];
    [_DislikeText release];
    [_PICPOST release];
    [_Commenter_Profile_Picture release];
    [_Commenter_TextPost release];
    [_Commenter_Name release];
    [_Comenter_PhotoPost release];
    [super dealloc];
}
   

- (IBAction)CommentBtn:(id)sender {
}
@end
