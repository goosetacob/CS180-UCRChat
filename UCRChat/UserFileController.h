//
//  UserFileController.h
//  UCRChat
//
//  Created by Gustavo Blanco on 11/9/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserFileController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{


    IBOutlet UIImageView *imageView;
    UIImagePickerController *pickPhoto;
    UIImage *image;
    //IBOutlet UIImagePickerController *imageC;

}
-(IBAction)showActionSheet:(id)sender;
@property (strong, nonatomic) NSString *currentUserId;
    
@end