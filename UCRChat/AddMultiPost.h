//
//  UIViewController+AddMultiPost.h
//  UCRChat
//
//  Created by user24887 on 11/23/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AddMultiPost : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

- (IBAction)BackBTN:(id)sender;
- (IBAction)SUMIT:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *Photo;
@property (strong, nonatomic) MPMoviePlayerController *VideoPost;
@property (retain, nonatomic) NSURL* URL;
- (IBAction)TakePic:(id)sender;
- (IBAction)SelectPic:(id)sender;
- (IBAction)TakeVid:(id)sender;
- (IBAction)SelecVid:(id)sender;

@end
