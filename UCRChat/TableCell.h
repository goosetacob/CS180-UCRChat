//
//  UITableViewCell+TableCell.h
//  UCRChat
//
//  Created by user24887 on 11/4/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TableCell : UITableViewCell
{
   PFObject *user; // The user associated with the cell
}

- (PFObject *) getUser;
- (void) setUser: (PFObject *)userobject;

@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ThumbImage;

@end
