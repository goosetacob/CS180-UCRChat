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
    
    NSArray *PostArray;
   
}
@property (retain, nonatomic) IBOutlet UITableView *PostTable;





@end
