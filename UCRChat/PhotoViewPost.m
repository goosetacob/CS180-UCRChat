//
//  UIViewController+PhotoViewPost.m
//  UCRChat
//
//  Created by user24887 on 11/26/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "PhotoViewPost.h"

@implementation PhotoViewPost

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.427 green:0.517 blue:0.705 alpha:1.0];

    _Post.image = _POST;
    _ProfilePicture.image = _Picture;
    _Name.text = _PARENT_NAME;
    
    bool found = false;
    
    //Check if we already lked the post to change the button text
    NSArray* temp_array = [_UserObject objectForKey:@"LikesID"];
    for (NSString* Item2 in temp_array)
    {
        if([[PFUser currentUser].username isEqualToString:Item2])
        {
            found = true;
            break;
        }
    }
    
    if(found) [_LikeButton setTitle:@"Liked" forState:UIControlStateNormal];
    else [_LikeButton setTitle:@"Like" forState:UIControlStateNormal];
    
    //Getting the ize of the comment array
    NSArray* array = [_UserObject objectForKey:@"Comments"];
    _CommentText.text = [NSString stringWithFormat:@"%ld", array.count ];
    //assining the number of likes
    _LikeText.text = [NSString stringWithFormat:@"%d", [[_UserObject objectForKey:@"Likes"] intValue] ];

}



- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Liketbtn:(id)sender {
}

- (IBAction)Commentbtn:(id)sender {
}
- (void)dealloc {
    [_ProfilePicture release];
    [_Post release];
    [_CommentButton release];
    [_LikeButton release];
    [_CommentText release];
    [_LikeText release];
    [_Name release];
    [super dealloc];
}
@end
