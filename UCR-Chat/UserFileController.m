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
    
    _currentUserId = [[PFUser currentUser] objectId];
    
    PFObject *userPointer = [PFObject objectWithClassName:@"_User"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:_currentUserId block:^(PFObject *userPointer, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        PFFile *pictureFile = userPointer[@"picture"];
        [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *tempImage = [UIImage imageWithData:data];
            [imageView setImage:tempImage];
        }];
        
        NSLog(@"%@", userPointer);
    }];
    
}

- (IBAction)returnToProfile:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Photos", nil];
    
    [actionSheet showInView:self.view];
}



-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [image drawInRect: CGRectMake(0, 0, 640, 640)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSData *imageData = UIImagePNGRepresentation(image);
    [self uploadImage:imageData];
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
        
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(640, 640));
        [image drawInRect: CGRectMake(0, 0, 640, 640)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    
    else if(buttonIndex == 1)
    {
        
        NSLog(@"Choose from Photos Button Clicked");
        pickPhoto = [[UIImagePickerController alloc] init];
        pickPhoto.delegate = self;
        pickPhoto.allowsEditing = YES;
        pickPhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:pickPhoto animated:YES completion:NULL];
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
    // Show progress
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Uploading";
    [HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *userPhoto = [PFUser currentUser];
            userPhoto[@"picture"] = imageFile;
            [userPhoto saveInBackground];
            [userPhoto setObject:imageFile forKey:@"picture"];
            [HUD hide:YES];
            
            // Set the access control list to current user for security purposes
            //userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            //PFUser *user = [PFUser currentUser];
           // [userPhoto setObject:user forKey:@"user"];
        }
        else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
