//
//  TimelineController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "TimelineController.h"

@interface TimelineController ()

@end

@implementation TimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
    _PostTable.dataSource = self;
    _PostTable.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    //storng objcts to cloud
    [self performSelector:@selector(retrieveFromParse)];
}

- (void) retrieveFromParse{
    PFQuery *retrievePosts = [PFQuery queryWithClassName:@"GlobalTimeline"];
    [retrievePosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            PostArray = [[NSArray alloc ] initWithArray:objects];
        }
        [_PostTable reloadData];
    }];
    
}



//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return PostArray.count;
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //setup cell
    PFObject *tempObject = [PostArray objectAtIndex:indexPath.row];
   
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text = [tempObject objectForKey:@"Post"];
   // cell.textLabel.text = [tempObject objectForKey:@"User"];

    return cell;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
   
   // [postText release];
   // [PostLabel release];
    [_PostTable release];
    [super dealloc];
}
@end