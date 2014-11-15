//
//  TimelineController.h
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TimelineController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *PostArray;
    NSArray* Left;
    NSArray* Right;
    
   
}
@property (retain, nonatomic) IBOutlet UITableView *PostTable;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
- (IBAction)LikeBTNUP:(id)sender;





@end
