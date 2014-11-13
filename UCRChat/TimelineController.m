//
//  TimelineController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "TimelineController.h"
#import "CustomCell.h"

@interface TimelineController ()

@end

@implementation TimelineController
@synthesize PostTable;
bool checkedlike = false;
static int numLikes = 0;

PFObject *tempObject;
CustomCell *cell;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) retrieveFromParse{
    PFQuery *retrievePosts = [PFQuery queryWithClassName:@"GlobalTimeline"];
    [retrievePosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            PostArray = [[NSMutableArray alloc ] initWithArray:objects];
        }
        
        [self.PostTable reloadData];
        [_refreshControl endRefreshing];
    }];
    
}



//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)PostArray.count);
    return PostArray.count;
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //setup cell
     tempObject = [PostArray objectAtIndex:indexPath.row];
   
    static NSString *CellIdentifier = @"mycell";
    
    cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
   
    [[cell Likebtn] addTarget:self action:@selector(Like:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.NAME.text = [tempObject objectForKey:@"User"];
    cell.POST.text = [tempObject objectForKey:@"Post"];
    cell.IMG.image = [UIImage imageNamed:@"Default Profile.jpg"];
    numLikes = [[tempObject objectForKey:@"Likes"] intValue];
    cell.LikeText.text = [NSString stringWithFormat:@"%d", numLikes ];
    
    
    
    
    return cell;
}

- (IBAction)Like:(id)sender {
    
    //[tempObject addUniqueObject:[PFUser currentUser].objectId forKey:@"LikesID"];
    [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error)
        {
            
            
            
            [tempObject incrementKey:@"Likes" byAmount:[NSNumber numberWithInt:1]];
            [tempObject addUniqueObject:[PFUser currentUser].objectId forKey:@"LikesID"];
            [tempObject saveInBackground];
             cell.LikeText.text = [NSString stringWithFormat:@"%d", [[tempObject objectForKey:@"Likes"] intValue]];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
   
    [PostTable release];
    [super dealloc];
}
@end