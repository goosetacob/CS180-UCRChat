//
//  UserFileController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 11/9/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "UserFileController.h"

@interface UserFileController () 
//- (void)actionSheet:(UIButton *)sender; //Declaration for Action Sheet
@end

@implementation UserFileController

- (IBAction)returnToProfile:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Photos", nil];
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
   // NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    //if ([buttonTitle isEqualToString:@"Destructive Button"])
      //  NSLog(@"Destructive pressed --> Delete Something");
    //else
      //  true;
    
    /*
    if (buttonIndex == 0)
        self.label.text = @"Destructive Button Clicked";
    else if (buttonIndex == 1)
        self.label.text = @"Take Photo Clicked";
    else if (buttonIndex == 2)
        self.label.text = @"Choose from Photos Clicked";
    else if (buttonIndex == 3)
        self.label.text = @"Cancel Button Clicked";
    */
    
//}

   
@end
