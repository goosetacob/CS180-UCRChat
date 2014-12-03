//
//  UITabBarController+ChatAppTabBarController.h
//  UCRChat
//
//  Created by Gustavo Blanco on 11/9/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#include <stdlib.h>

@interface ChatAppTabBarController : UITabBarController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>{
    
    MBProgressHUD *refreshHUD;
    UIImage *image;
}

@end
