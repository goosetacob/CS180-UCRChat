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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end