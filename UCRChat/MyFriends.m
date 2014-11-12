//
//  MyFriends.m
//  UCRChat
//
//  Created by user26338 on 11/12/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "MyFriends.h"
#import <Parse/Parse.h>
#import "TableCell.h"


@interface MyFriends ()

@end

@implementation MyFriends


@synthesize myTableView;


- (void) retrieveFromParse
{
    PFQuery *ret = [PFQuery queryWithClassName:@"_User"];
    [ret findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if( !error )
        {
            userArray = [ [NSArray alloc] initWithArray:objects ];
        }
        else
        {
            NSLog( @"ERROR querying data!");
        }
    }];
    
    [self.myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"in myFriends didLoad");

    // Set TableView delegate and data source
    [myTableView setDataSource:self];
    [myTableView setDelegate:self];

    // Perform a query on our User database in Parse.
    //[self performSelector:@selector(retrieveFromParse)];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(retrieveFromParse) userInfo:nil repeats:YES];
    //[self grabParseData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"In myFriends. sections count");
    // Return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Display the number of rows in the section
    NSLog(@"In myFriends. tableView rows count: %lu", (unsigned long)Title.count);

    return userArray.count;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"in myFriends tableView\n");

    
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    
    if( !cell )
    {
        cell = [ [TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier ];
    }
    
    PFObject *tempObject = [userArray objectAtIndex:indexPath.row ];
    
    cell.TitleLabel.text = [tempObject objectForKey:@"fullName"];
    cell.DescriptionLabel.text = [tempObject objectForKey:@"aboutMe"];
    cell.ThumbImage.image = [tempObject objectForKey:@"picture"];
    

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
