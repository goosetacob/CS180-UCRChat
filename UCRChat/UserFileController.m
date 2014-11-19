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
@synthesize currentUserId = _currentUserId;

- (void)viewDidLoad {
    [super viewDidLoad];
}

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



-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSData *imageData = UIImagePNGRepresentation(image);
    [self uploadImage:imageData];
    
    /*
    PFObject *userPointer = [PFObject objectWithClassName:@"_User"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:_currentUserId block:^(PFObject *userPointer, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSData *imageData = UIImagePNGRepresentation(image);
        
        PFFile *imageFile = [PFFile fileWithName:@"profileimage.jpg" data:imageData];
        
        userPointer[@"picture"] = imageFile;
        [userPointer saveInBackground];
        
        
        NSLog(@"%@", userPointer);
    }];*/
}

 
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        NSLog(@"Take Photo Button Clicked");
        pickPhoto = [[UIImagePickerController alloc] init];
        pickPhoto.delegate = self;
        [pickPhoto setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:pickPhoto animated:YES completion:NULL];
        [pickPhoto release];
        
    }
    
    else if(buttonIndex == 1)
    {
        
        NSLog(@"Choose from Photos Button Clicked");
        pickPhoto = [[UIImagePickerController alloc] init];
        pickPhoto.delegate = self;
        pickPhoto.allowsEditing = YES;
        pickPhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:pickPhoto animated:YES completion:NULL];
        [pickPhoto release];
    }
    
    else if(buttonIndex == 2)
    {
        
        NSLog(@"Cancel Button Clicked");
        
    }
    
}

-(void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            PFObject *userPhoto = [PFUser currentUser];
            userPhoto[@"picture"] = imageFile;
            [userPhoto saveInBackground];
            //[userPhoto setObject:imageFile forKey:@"picture"];
            
            // Set the access control list to current user for security purposes
            //userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            //PFUser *user = [PFUser currentUser];
           // [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
    HUD = nil;
}

-(IBAction)refresh:(id)sender
{
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD show:YES];
}


@end
