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
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Update_info) userInfo:nil repeats:YES];
    self.view.backgroundColor = [UIColor colorWithRed:0.427 green:0.517 blue:0.705 alpha:1.0];
    PostControllerPost.backgroundColor = [UIColor colorWithRed:0.427 green:0.517 blue:0.705 alpha:1.0];
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
    bool Objectfound = false;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:PARENT_POST options:0 range:NSMakeRange(0, [PARENT_POST length])];
    for (NSTextCheckingResult *match in matches)
    {
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSURL *url = [match URL];
            
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:PARENT_POST];
            [str addAttribute: NSLinkAttributeName value:url range: match.range];
            PostControllerPost.attributedText = str;
            
            Objectfound = true;
            break;
        }
    }
    if(!Objectfound) PostControllerPost.text = PARENT_POST;
    
    
    
    //Getting the ize of the comment array
     NSArray* array = [UserObject objectForKey:@"Comments"];
    CommentLabel.text = [NSString stringWithFormat:@"%ld", array.count ];
    //assining the number of likes
    LikeLabel.text = [NSString stringWithFormat:@"%d", [[UserObject objectForKey:@"Likes"] intValue] ];
    
    
    /*Proccsng for th picture */
    
    PostControllerPIC.image = ProfilePicture;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
    return YES;
}
- (void) Update_info{
    LikeLabel.text = [NSString stringWithFormat:@"%d", [[UserObject objectForKey:@"Likes"] intValue] ];
    NSArray* tmp = [UserObject objectForKey:@"Comments"];
    CommentLabel.text = [NSString stringWithFormat:@"%d", (int) tmp.count];
}

//sending the seugue nformatoion to the view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"sendID"])
    {
        //Creating the controller vieww where i will send the information
        PostComment *PostController = segue.destinationViewController;
        PostController.CommentID = UserObject.objectId;
        PostController.CurrentUserNAME = self.CurrentUserNAME;
        PostController.CurrentUserImage = self.CurrentUserImage;
        PostController.CurrentObject = self.CurrentObject;
        
       // NSLog(@"To Post Comment: %@", self.CurrentUserImage)
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
