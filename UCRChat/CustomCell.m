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
    [_CommentBox release];
    [_CommentBtn release];
    [_Delete release];
    [_LoadingPicture release];
    [_ColorView release];
    [_Date release];
    [super dealloc];
}
   

- (IBAction)CommentBtn:(id)sender {
}
@end
