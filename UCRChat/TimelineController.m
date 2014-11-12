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

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor blackColor];
    self.PostTable.dataSource = self;
    self.PostTable.delegate = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(retrieveFromParse) forControlEvents:UIControlEventValueChanged];
    
    [self.PostTable addSubview:_refreshControl];
    [self.PostTable reloadData];
    
    [self retrieveFromParse ];
    
    
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
    PFObject *tempObject = [PostArray objectAtIndex:indexPath.row];
   
    static NSString *CellIdentifier = @"mycell";
    
    CustomCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    cell.NAME.text = [tempObject objectForKey:@"User"];
    cell.POST.text = [tempObject objectForKey:@"Post"];
    cell.IMG.image = [UIImage imageNamed:@"Default Profile.jpg"];
    
    return cell;
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