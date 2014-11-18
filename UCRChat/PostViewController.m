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
@synthesize PostControllerPIC, PostControllerName, CommentLabel, ObjectID, LikeLabel, PostControllerPost, PARENT_NAME, PARENT_POST, PARENT_LIKE, PARENT_COMMENT, LikeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    PostControllerName.text = PARENT_NAME;
    PostControllerPost.text = PARENT_POST;
    CommentLabel.text = PARENT_COMMENT;
    LikeLabel.text = PARENT_LIKE;
    PostControllerPIC.image = [UIImage imageNamed:@"Default Profile.jpg"];
    
    PFQuery *retrievePosts = [PFQuery queryWithClassName:@"GlobalTimeline"];
    [retrievePosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
             Parray = [[NSMutableArray alloc ] initWithArray:objects];
     }];
    
    for(PFObject* item in Parray)
    {
        if([item.objectId isEqualToString:ObjectID])
        {
            //Check if we already lked the post to change the button text
            NSArray* temp_array = [item objectForKey:@"LikesID"];
            for (NSString* Item2 in temp_array) {
                if([[PFUser currentUser].username isEqualToString:Item2])
                    [LikeButton setTitle:@"Liked" forState:UIControlStateNormal];
            }
        }
    }

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
    [super dealloc];
}

- (IBAction)Cbtn:(id)sender {
}

- (IBAction)Lbtn:(id)sender {
    UIButton *LButton = (UIButton * )sender;
    
    PFQuery *retrievePosts = [PFQuery queryWithClassName:@"GlobalTimeline"];
    [retrievePosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
             Parray = [[NSMutableArray alloc ] initWithArray:objects];
     }];
    
    for(PFObject* item in Parray)
    {
        //is the current object
        if([item.objectId isEqualToString:ObjectID])
        {
            //Get the object array of likes to see if we already liked it or not
            NSMutableArray* tmp_Array = [item objectForKey:@"LikesID"] ;
            bool found = false;
            
            //check if we already liked it
            for(id item2 in tmp_Array)
            {
                if([item2 isEqualToString:[PFUser currentUser].username])
                    found = true;
                
                
            }
            
            //If we have not liked it then we are going to likee it and add to the array
            if(found == false)
            {
                //Like Feauture
                [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     if(!error)
                     {
                         [item incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:1]];
                         [item addUniqueObject:[PFUser currentUser].username forKey:@"LikesID"];
                         [item saveInBackground];
                         [LButton setTitle:@"Liked" forState:UIControlStateNormal];
                     }
                 }];
            }
            //Dislike Feauture
            else
            {
                [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     if(!error)
                     {
                         [item incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:-1]];
                         //Obtain array of LIKESId
                         for(id i in tmp_Array)
                         {
                             if([i isEqualToString:[PFUser currentUser].username]){
                                 [tmp_Array removeObject: i];
                                 [item saveInBackground];
                                 [LButton setTitle:@"Like" forState:UIControlStateNormal];
                             }
                         }
                         
                     }
                 }];
            }
            LikeLabel.text = [NSString stringWithFormat:@"%d",[[item objectForKey:@"Likes"]intValue]];
            break;
        }
    }

}
@end
