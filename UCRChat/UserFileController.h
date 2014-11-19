//
//  UserFileController.h
//  UCRChat
//
//  Created by Gustavo Blanco on 11/9/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#include <stdlib.h>


@interface UserFileController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>{


    IBOutlet UIScrollView *photoScrollView;
    NSMutableArray *allImages;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
    
    IBOutlet UIImageView *imageView;
    UIImagePickerController *pickPhoto;
    UIImage *image;
    //IBOutlet UIImagePickerController *imageC;

}
-(IBAction)showActionSheet:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (IBAction)refresh:(id)sender;


@property (strong, nonatomic) NSString *currentUserId;
    
@end