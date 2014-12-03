//
//  UIViewController+Visibility.h
//  UCRChat
//
//  Created by user24887 on 12/2/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface  Visibility : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray* VisibleFriends;
    NSMutableArray* Friends;
    NSMutableArray* temp;
    NSInteger CurrentRow;
}

//- (IBAction)Back:(id)sender;
- (IBAction)Add:(id)sender;
@property (retain, nonatomic) IBOutlet UIPickerView *NamePicker;

@property (retain, nonatomic) NSString* CurrentUser;
- (IBAction)Clear:(id)sender;
- (IBAction)All:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *SegueViewController;

@end
