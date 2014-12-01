//
//  UIViewController+PhotoViewPost.m
//  UCRChat
//
//  Created by user24887 on 11/26/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "PhotoViewPost.h"
#import "PostComment.h"

@implementation PhotoViewPost

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Update_info) userInfo:nil repeats:YES];
    self.view.backgroundColor = [UIColor colorWithRed:0.427 green:0.517 blue:0.705 alpha:1.0];

    NSNumber* mybool =  _UserObject[@"PhotoPost"];
    NSNumber* mybool2 = _UserObject[@"VideoPost"];
    bool Photo =  [mybool boolValue];
    bool Video = [mybool2 boolValue];
    
   
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
    
    NSArray* tmp = [_UserObject objectForKey:@"Comments"];
    _CommentText.text = [NSString stringWithFormat:@"%d", (int) tmp.count];
    
    if(Photo) _Post.image = _POST;
    else if(Video)
    {
        if(_VideoURL != nil){
            MPMoviePlayerController* movie = [[MPMoviePlayerController alloc] initWithContentURL:_VideoURL];
           
            CGRect frame = CGRectMake(20, 200, 20 + 250, 200 + 150);
            movie.scalingMode = MPMovieScalingModeAspectFit;
            movie.shouldAutoplay = YES;
            [[movie view] setFrame:frame];
            [[self view] addSubview: [movie view]];
            [movie prepareToPlay];
            [movie play];
        }
    }
}
- (void) Update_info{
     _LikeText.text = [NSString stringWithFormat:@"%d", [[_UserObject objectForKey:@"Likes"] intValue] ];
     NSArray* tmp = [_UserObject objectForKey:@"Comments"];
     _CommentText.text = [NSString stringWithFormat:@"%d", (int) tmp.count];
}

//sending the seugue nformatoion to the view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"sendID2"])
    {
        //Creating the controller vieww where i will send the information
        PostComment *PostController = segue.destinationViewController;
        PostController.CommentID = _UserObject.objectId;
        PostController.CurrentUserNAME = self.CurrentUserNAME;
        PostController.CurrentUserImage = self.CurrentUserImage;
        PostController.CurrentObject = self.CurrentObject;
        
        // NSLog(@"To Post Comment: %@", self.CurrentUserImage)
    }
}

- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Liketbtn:(id)sender {
    //ParseObecjt now has the object we are goind to update.
    NSMutableArray* tmp_Array = [_UserObject objectForKey:@"LikesID"] ;
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
        [_UserObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"Not found in the Array");
                 [_UserObject incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:1]];
                 [_UserObject addUniqueObject:[PFUser currentUser].username forKey:@"LikesID"];
                 [_UserObject saveInBackground];
                 [_LikeButton setTitle:@"Liked" forState:UIControlStateNormal];
                 _LikeText.text = [NSString stringWithFormat:@"%d", [[_UserObject objectForKey:@"Likes"] intValue]];
             }
         }];
        found = true;
    }
    //Dislike Feauture
    //If the user has alredy liked the post, then it removes itself fro the likes array and updates the number of likes minus one and changes the button label to like from liked
    else
    {
        [_UserObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(!error)
             {
                 [_UserObject incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:-1]];
                 //Obtain array of LIKESId
                 for(id item in tmp_Array)
                 {
                     if([item isEqualToString:[PFUser currentUser].username]){
                         [tmp_Array removeObject: item];
                         [_UserObject saveInBackground];
                         [_LikeButton setTitle:@"Like" forState:UIControlStateNormal];
                         _LikeText.text = [NSString stringWithFormat:@"%d", [[_UserObject objectForKey:@"Likes"] intValue]];
                     }
                 }
                 
             }
         }];
    }
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
