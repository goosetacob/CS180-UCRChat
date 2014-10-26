//
//  ChatController.m
//  UCRChat
//
//  Created by Gustavo Blanco on 10/22/14.
//  Copyright (c) 2014 me.gustavob. All rights reserved.
//

#import "ChatController.h"

@interface ChatController ()

@end

@implementation ChatController
    NSArray *tableData;
    
    - (void)viewDidLoad {
        [super viewDidLoad];
        
        // Initialize table data
        tableData = [NSArray arrayWithObjects:@"Gustavo Blanco", @"Sergio Morales", @"Fernando Gonzalez", @"Hector Dominguez", nil];
    }

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [tableData count];
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    
        cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
        return cell;
    }

@end
