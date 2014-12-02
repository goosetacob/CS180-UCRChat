#import "AddPostController.h"

@interface AddPostController ()

@end

@implementation AddPostController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tabBarController.selectedIndex = 4;
    self.view.backgroundColor = [UIColor colorWithRed:0.427 green:0.517 blue:0.705 alpha:1.0];
    _Textview.dataDetectorTypes = UIDataDetectorTypeLink;
    [_Textview becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_DonePost release];
    [_Textview release];
    [super dealloc];
}

- (IBAction)returnToPrevious:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)BtnPressed:(id)sender {
    
    if([self.Identifier isEqualToString:@"Postsegue"]){
        //storng objcts to cloud
        PFObject *GlobalTimeline =  [PFObject objectWithClassName:@"GlobalTimeline"];
        NSString *str = [[NSString alloc] initWithFormat:_Textview.text];
        if([str length] != 0) {
            GlobalTimeline[@"Post"] = str;
            GlobalTimeline[@"User"] = [PFUser currentUser].username;
            GlobalTimeline[@"Likes"] = [NSNumber numberWithInt:0];
            GlobalTimeline[@"Dislikes"] = [NSNumber numberWithInt:0];
            GlobalTimeline[@"PhotoPost"] = [NSNumber numberWithBool:NO];
            GlobalTimeline[@"VideoPost"] = [NSNumber numberWithBool:NO];
            [GlobalTimeline saveInBackground];
        }
    }
    if([self.Identifier isEqualToString:@"CommentPost"])
    {
        NSString *str = [[NSString alloc] initWithFormat:_Textview.text];
        PFObject* MyComment = [PFObject objectWithClassName:@"PostCommentObject"];
        if([str length] != 0) {
            
            //First we need to create the object to be inserted into the array of commets
            MyComment[@"Name"] = self.CurrentUserNAME;
            MyComment[@"TextComment"] = str;
            
            NSData* data = UIImageJPEGRepresentation(self.CurrentUserImage, 0.5f);
            PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
            MyComment[@"ProfilePicture"] = imageFile;
            MyComment[@"Text"] = [NSNumber numberWithBool:YES];
            MyComment[@"Photo"] = [NSNumber numberWithBool:NO];
            MyComment[@"Video"] = [NSNumber numberWithBool:NO];
            //Then we need to get the array andd add to to the array list
            [MyComment save];
            
            [self.CurrentObject addUniqueObject:MyComment.objectId forKey:@"Comments"];
            [self.CurrentObject saveInBackground];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end