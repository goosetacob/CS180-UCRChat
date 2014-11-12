#import "AddPostController.h"

@interface AddPostController ()

@end

@implementation AddPostController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tabBarController.selectedIndex = 4;
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
- (IBAction)BtnPressed:(id)sender {
    //storng objcts to cloud
    PFObject *GlobalTimeline =  [PFObject objectWithClassName:@"GlobalTimeline"];
    NSString *str = [[NSString alloc] initWithFormat:_Textview.text];
    GlobalTimeline[@"Post"] = str;
    GlobalTimeline[@"User"] = [PFUser currentUser].username;
    [GlobalTimeline saveInBackground];
}
@end