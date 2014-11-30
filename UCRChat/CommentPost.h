//
//  NSObject+CommentPost.h
//  UCRChat
//
//  Created by user24887 on 11/29/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CommentPost : NSObject
{
    @public
    bool Photo;
}

//Properties that wll be displayed on the commet section
@property (retain, nonatomic) UIImage* Profile_Image;
@property (retain, nonatomic) UIImage* Post_Image;
@property (retain, nonatomic) NSString* Post_text;
@property (retain, nonatomic) NSString* User_Text;


@end
