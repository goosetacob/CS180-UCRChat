//
//  UIViewController+PostComment.h
//  UCRChat
//
//  Created by user24887 on 11/29/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CommentPost.h"
#import "CustomCell.h"

@interface PostComment : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* CPostArray;
}
@property (retain, nonatomic) IBOutlet UITableView *Comment_Table;
@property (retain, nonatomic) NSString *CommentID;
@property (strong, nonatomic) NSString *CurrentUserNAME;
@property (strong, nonatomic) UIImage  *CurrentUserImage;
@property (strong, nonatomic) PFObject  *CurrentObject;;


- (IBAction)backbtn:(id)sender;

@end
