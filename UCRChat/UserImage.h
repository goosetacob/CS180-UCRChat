//
//  NSObject+UserImage.h
//  UCRChat
//
//  Created by user24887 on 11/21/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserImages : NSObject
@property (retain, nonatomic) NSString* objectID;
@property (retain, nonatomic) UIImage* Image;
@end
