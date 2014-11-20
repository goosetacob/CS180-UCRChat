//
//  TimelineController.h
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TimelineController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    
    NSMutableArray *PostArray;
    NSMutableArray *NewPostArray;
    NSArray *userarray;
    NSArray* Left;
    NSArray* Right;
    PFObject* deleteObject;
}

@property (retain, nonatomic) IBOutlet UITableView *PostTable;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
- (IBAction)LikeBTNUP:(id)sender;
- (IBAction)commentBTNUP:(id)sender;


@property (retain, nonatomic) IBOutlet UIButton *AddBtn;
- (IBAction)AddActionButton:(id)sender;
- (IBAction)DeleteBTN:(id)sender;

@end
