//
//  UIViewController+Visibility.m
//  UCRChat
//
//  Created by user24887 on 12/2/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "Visibility.h"
#import "AddPostController.h"
NSArray* VFriends;
@implementation Visibility

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (id)initWithCoder: (NSCoder *) aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        VisibleFriends = [[NSMutableArray alloc] init];
        Friends = [[NSMutableArray alloc] init];
        temp = [[NSMutableArray alloc] init];
        _NamePicker = [[UIPickerView alloc] init];
        CurrentRow = 0;
    }
    return self;
}
-(void) viewWillAppear: (BOOL) animated {
    [self PULLFRIENDS];
   [_NamePicker reloadAllComponents];
}

-(void) PULLFRIENDS
{
    NSString *friendId = [PFUser currentUser ][@"friendClassId"];
    
    // Query objectID to grab Friends array
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query getObjectInBackgroundWithId:friendId block:^(PFObject *object, NSError *error)
     {
         if (!error)
         {
             // Do something with the found friend array
             temp = [object objectForKey:@"Friends"];
                         for(NSString* item in temp)
             {
                                  // Query objectID to grab Friends array
                 PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                 [query getObjectInBackgroundWithId:item block:^(PFObject *object, NSError *error)
                  {
                      if (!error) {
                          // Do something with the found friend array
                          bool found = false;
                          NSString* name = [object objectForKey:@"fullName"];
                          for(NSString* check in Friends)
                              if([name isEqualToString:check]) found = true;
                          
                          if(!found) [Friends addObject:name];
                          found = false;
                      }
                  }];
             }
            
             [_NamePicker reloadAllComponents];
         }
     }];
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Connect data
    self.NamePicker.dataSource = self;
    self.NamePicker.delegate = self;
    [_NamePicker reloadAllComponents];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PULLFRIENDS) userInfo:nil repeats:YES];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return Friends.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CurrentRow = (NSInteger)row;
    return Friends[row];
}

/*
//sending the seugue nformatoion to the view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    //[self dismissViewControllerAnimated:YES completion:^{
     
        if ([[segue identifier] isEqualToString:@"DoneVisibilityView"])
        {
            //Creating the controller vieww where i will send the information
            AddPostController *PostController = segue.destinationViewController;
            PostController.VisibilityArray = VisibleFriends;
            PostController.Identifier = @"Postsegue";
            NSLog(@"===================================Segue: %@", VisibleFriends);
        }
       // }];
}
*/
- (IBAction)Back:(id)sender {
   // AddPostController* postcontroller = [[AddPostController alloc] initWithNibName:@"AddPostController" bundle:nil];
   // NSLog(@"Self-------------------------------> %@", [self.SegueViewController class]);
    
    VFriends = VisibleFriends;
    //[[self navigationController] popViewControllerAnimated:true];
    //[self popoverPresentationController];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Add:(id)sender {
    [VisibleFriends addObject: [self pickerView:_NamePicker titleForRow:CurrentRow forComponent:0]];
}
- (IBAction)Clear:(id)sender {
    [VisibleFriends removeAllObjects];
}

- (IBAction)All:(id)sender {
    VisibleFriends = [[NSMutableArray alloc] initWithArray:Friends];
}
@end
