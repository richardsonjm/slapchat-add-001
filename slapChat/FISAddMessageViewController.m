//
//  FISAddMessageViewController.m
//  slapChat
//
//  Created by John Richardson on 7/13/16.
//  Copyright © 2016 Joe Burgess. All rights reserved.
//

#import "FISAddMessageViewController.h"
#import "FISMessage.h"
#import "FISDataStore.h"

@interface FISAddMessageViewController ()

@end

@implementation FISAddMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)saveMessageButton:(id)sender {
    FISDataStore *store = [FISDataStore sharedDataStore];
    FISMessage *newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"FISMessage" inManagedObjectContext:store.managedObjectContext];
    newMessage.content = self.messageTextField.text;
    newMessage.createdAt = [NSDate date];
    [store saveContext];
    
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)cancelNewMessageButton:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}
@end
