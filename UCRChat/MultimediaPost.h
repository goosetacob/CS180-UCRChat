//
//  NSObject+MultimediaPost.h
//  UCRChat
//
//  Created by user24887 on 11/24/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MultimediaPost : NSObject

@property (retain, nonatomic) NSString* UserID;
@property (retain, nonatomic) NSString* objectID;
@property (retain, nonatomic) UIImage* Image;
@property (retain, nonatomic) MPMoviePlayerController *VideoPost;

@end
