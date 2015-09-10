//
//  FISTableViewController.m
//  slapChat
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISTableViewController.h"
#import "Message.h"

@interface FISTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation FISTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.store = [FISDataStore sharedDataStore];
    self.tableView.accessibilityLabel = @"mainTableView";
    self.addButton.accessibilityLabel = @"addButton";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.store fetchData];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.store.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basiccell" forIndexPath:indexPath];
    
    Message *eachMessage = self.store.messages[indexPath.row];
    
    cell.textLabel.text = eachMessage.content;
    
    return cell;
}
@end
