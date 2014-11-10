//
//  User.h
//  UCRChat
//
//  Created by Gustavo Blanco on 11/8/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) UIImage *picture;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *timelinePost;

- (void) addFriend: (NSString *) friendObjectId;

@end
