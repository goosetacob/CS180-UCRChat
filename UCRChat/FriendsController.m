//
//  TimelineController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "FriendsController.h"
#import <Parse/Parse.h>
#import "UITableViewCell+TableCell.h"

@interface FriendsController ()

@end

@implementation FriendsController

@synthesize Images = _Images;
@synthesize Title = _Title;
@synthesize Description = _Description;

- (id)initWithStyle:(UITableViewStyle)style
 {
 self = [super initWithStyle: style];
 if( self ) {
 // Custom initialization
 }
 
 return self;
 }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _Title = @[@"Friend1",
               @"Friend2",
               @"Friend3",];
    
    _Description = @[@"Desc1",
                     @"Desc2",
                     @"Desc3",];
    
   // _Images = @[@"photo-placeholder.png",
  //              @"photo-placeholder.png",
    //            @"photo-placeholder.png",];
    
    //storng objcts to cloud
    //PFObject *User =  [PFObject objectWithClassName:@"User"];
    //User[@"Username"] = @"Hdomi001";
    
    //UIImage *img = [UIImage imageNamed:@"Picture"];
    // NSData *imagedata = UIImageJPEGRepresentation(<#UIImage *image#>, 50);
    //User[@"Picture"]  = imagedata;
    //[User saveInBackground];
    
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Display the number of rows in the section
    return _Title.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    
    // Configure the cell
    int row = (int) [indexPath row];
    
    cell.TitleLabel.text = _Title[row];
    cell.DescriptionLabel.text = _Description[row];
    //cell.ThumbImage.image = [UIImage imageNamed: _Images[row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end