//
//  FISTableViewController.m
//  slapChat
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISTableViewController.h"
#import "FISMessage.h"

@interface FISTableViewController ()

@end

@implementation FISTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.store = [FISDataStore sharedDataStore];
    [self.store fetchData];
    self.managedMessageObjects = self.store.messages;
    
    if ([self.managedMessageObjects count] < 1) {
        [self generateTestData];
    }
    
}

- (void)generateTestData {
    FISMessage *message1 = [NSEntityDescription insertNewObjectForEntityForName:@"FISMessage" inManagedObjectContext:self.store.managedObjectContext];
    message1.content = @"Message number 1";
    message1.createdAt = [NSDate date];
    
    FISMessage *message2 = [NSEntityDescription insertNewObjectForEntityForName:@"FISMessage" inManagedObjectContext:self.store.managedObjectContext];
    message2.content = @"Message number 2";
    message2.createdAt = [NSDate date];
    
    FISMessage *message3 = [NSEntityDescription insertNewObjectForEntityForName:@"FISMessage" inManagedObjectContext:self.store.managedObjectContext];
    message3.content = @"Message number 3";
    message3.createdAt = [NSDate date];
    [self.store saveContext];
    [self.store fetchData];
    self.managedMessageObjects = self.store.messages;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.store.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *SimpleIdentifier = @"SimpleIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleIdentifier];
    }
    
    FISMessage *message = self.managedMessageObjects[indexPath.row];
    
    cell.textLabel.text = message.content;

    // Configure the cell...
    
    return cell;
}

@end


/*

+NSEntityDescription insertNewObjectForEntityForName:inManagedObjectContext:

*/