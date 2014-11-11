//
//  User.m
//  UCRChat
//
//  Created by Gustavo Blanco on 11/8/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "User.h"

@interface User ()
@property (strong) NSString *objectId;

@end


@implementation User

@synthesize objectId = _objectId;
@synthesize userName = _userName;
@synthesize friends = _friends;
@synthesize timelinePost = _timelinePost;

- (instancetype) init {
    self = [super init];
    
    //make sure the User Object get initializezd properly
    if(self) {
        if ([PFUser currentUser]) {
            _objectId = [[PFUser currentUser] objectId];
        }
        
        //if the user already exists
        if ( nil ) {
            
        }
        
    }
    
    return self;
}

- (void) addFriend: (NSString *) friendObjectId {
    
}

//setters to change User properties here and on Parse
- (void) setUserName:(NSString *)userName {
    _userName = userName;
}

- (void) setPicture:(UIImage *)picture {
    
}

@end