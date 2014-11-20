//
//  UITableViewController+PostViewController.m
//  UCRChat
//
//  Created by user24887 on 11/16/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//
#import "PostViewController.h"
#import "TimelineController.h"

@interface PostViewController ()

@end

@implementation PostViewController
@synthesize PostControllerPIC, PostControllerName, CommentLabel, ObjectID, LikeLabel, PostControllerPost, PARENT_NAME, PARENT_POST, LikeButton, UserObject, ProfilePicture, Loading;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //loading indicator
    [self.view addSubview: Loading];
    [Loading startAnimating];
    
    bool found = false;
    
    //Check if we already lked the post to change the button text
    NSArray* temp_array = [UserObject objectForKey:@"LikesID"];
    for (NSString* Item2 in temp_array)
    {
        if([[PFUser currentUser].username isEqualToString:Item2])
        {
            found = true;
            break;
        }
    }
    
    if(found) [LikeButton setTitle:@"Liked" forState:UIControlStateNormal];
    else [LikeButton setTitle:@"Like" forState:UIControlStateNormal];
    
    //assign the labels its upated data
    PostControllerName.text = PARENT_NAME;
    PostControllerPost.text = PARENT_POST;
    //Getting the ize of the comment array
     NSArray* array = [UserObject objectForKey:@"Comments"];
    CommentLabel.text = [NSString stringWithFormat:@"%ld", array.count ];
    //assining the number of likes
    LikeLabel.text = [NSString stringWithFormat:@"%d", [[UserObject objectForKey:@"Likes"] intValue] ];
    
    
    /*Proccsng for th picture */
    
    PostControllerPIC.image = [UIImage imageNamed:@"Default Profile.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PostBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {

    [PostControllerPIC release];
    [PostControllerName release];
    [PostControllerPost release];
    
    [LikeLabel release];
    [LikeButton release];
    [Loading release];
    [super dealloc];
}

- (IBAction)Cbtn:(id)sender {
}

- (IBAction)Lbtn:(id)sender {
    
    //ParseObecjt now has the object we are goind to update.
    NSMutableArray* tmp_Array = [UserObject objectForKey:@"LikesID"] ;
    bool found = false;
    //obtains the Likes array nd checks if the user liked thi post
    for(id item in tmp_Array)
    {
        if([item isEqualToString:[PFUser currentUser].username])
            found = true;
    }
    
    //If the user has not liked the post then it ikes the posts updats the likes array with it name and updates the number of ikes by one
    if(found == false)
    {
        //Like Feauture
        [UserObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"Not found in the Array");
                 [UserObject incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:1]];
                 [UserObject addUniqueObject:[PFUser currentUser].username forKey:@"LikesID"];
                 [UserObject saveInBackground];
                 [LikeButton setTitle:@"Liked" forState:UIControlStateNormal];
                 LikeLabel.text = [NSString stringWithFormat:@"%d", [[UserObject objectForKey:@"Likes"] intValue]];
             }
         }];
        found = true;
    }
    //Dislike Feauture
    //If the user has alredy liked the post, then it removes itself fro the likes array and updates the number of likes minus one and changes the button label to like from liked
    else
    {
        [UserObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(!error)
             {
                 [UserObject incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:-1]];
                 //Obtain array of LIKESId
                 for(id item in tmp_Array)
                 {
                     if([item isEqualToString:[PFUser currentUser].username]){
                         [tmp_Array removeObject: item];
                         [UserObject saveInBackground];
                         [LikeButton setTitle:@"Like" forState:UIControlStateNormal];
                         LikeLabel.text = [NSString stringWithFormat:@"%d", [[UserObject objectForKey:@"Likes"] intValue]];
                    }
                 }
                 
             }
         }];
    }


}
@end
