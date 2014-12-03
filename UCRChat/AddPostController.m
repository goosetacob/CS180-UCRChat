#import "AddPostController.h"
#import "Visibility.h"

@interface AddPostController ()

@end

@implementation AddPostController


- (id)initWithCoder: (NSCoder *) aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
    }
    return self;
}
- (void) viewWillAppear: (BOOL) animated{
    
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tabBarController.selectedIndex = 4;
    self.view.backgroundColor = [UIColor colorWithRed:0.427 green:0.517 blue:0.705 alpha:1.0];
    _Textview.dataDetectorTypes = UIDataDetectorTypeLink;
    [_Textview becomeFirstResponder];
    
    if([self.Identifier isEqualToString:@"CommentPost"]) _VisiblityBTN.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_DonePost release];
    [_Textview release];
    [_VisiblityBTN release];
    [super dealloc];
}

- (IBAction)returnToPrevious:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//sending the seugue nformatoion to the view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"VisibilitySegue"])
    {
        //Creating the controller vieww where i will send the information
        Visibility *PostController = segue.destinationViewController;
        PostController.CurrentUser = [PFUser currentUser].objectId;
    }
}

- (IBAction)BtnPressed:(id)sender {
    
    if([self.Identifier isEqualToString:@"Postsegue"]){
        //storng objcts to cloud
        GlobalTimeline =  [PFObject objectWithClassName:@"GlobalTimeline"];
        NSString *str = [[NSString alloc] initWithFormat:_Textview.text];
        if([str length] != 0) {
            GlobalTimeline[@"Post"] = str;
            GlobalTimeline[@"User"] = [PFUser currentUser].username;
            GlobalTimeline[@"Likes"] = [NSNumber numberWithInt:0];
            GlobalTimeline[@"Dislikes"] = [NSNumber numberWithInt:0];
            GlobalTimeline[@"PhotoPost"] = [NSNumber numberWithBool:NO];
            GlobalTimeline[@"VideoPost"] = [NSNumber numberWithBool:NO];
            [GlobalTimeline save];
        
            NSLog(@"---------------------------------------------Visibility Array %@", VFriends);
            for(NSString* item in VFriends)
            {
                [GlobalTimeline addUniqueObject:item forKey:@"Visibility"];
                [GlobalTimeline save];
            }
           
            
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

- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end