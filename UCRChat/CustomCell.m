//
//  UITableViewCell+CustomCell.m
//  UCRChat
//
//  Created by user24887 on 11/11/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "CustomCell.h"
@implementation CustomCell
static int liked = 0;


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
    [super dealloc];
}
- (IBAction)Like:(id)sender {
    if (liked == 0) {
        liked = 1;
        
        
       /* PFQuery *retrieve = [PFQuery queryWithClassName:@"GlobalTimeline"];
        [retrieve getObjectInBackgroundWithId:currentuser. block:<#^(PFObject *object, NSError *error)block#>{
            
        }
            

        PFObject *tempObj = [tempArray objectAtIndex:indexPath.row];
            
        
        //int counter = [tempObj objectForKey:@"Likes"];
      //  counter++;
        */
        
    }
   
   // _LikeText.text = str;
}
@end
