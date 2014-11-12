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
        
    }
    
    else if(buttonIndex == 1)
    {
        
        NSLog(@"Choose from Photos Button Clicked");
        pickPhoto = [[UIImagePickerController alloc] init];
        pickPhoto.delegate = self;
        [pickPhoto setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:pickPhoto animated:YES completion:NULL];
        [pickPhoto release];
    }
    
    else if(buttonIndex == 2)
    {
        
        NSLog(@"Cancel Button Clicked");
        
    }
}
    
@end
