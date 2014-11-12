//
//  UITableViewCell+TableCell.m
//  UCRChat
//
//  Created by user24887 on 11/4/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self)
    {

    }
    return self;

}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selecte state
}
@end
