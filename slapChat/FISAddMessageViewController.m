//
//  FISAddMessageViewController.m
//  slapChat
//
//  Created by Chris Gonzales on 9/15/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISAddMessageViewController.h"
#import "Message.h"
#import "FISDataStore.h"

@interface FISAddMessageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *messageContentField;
@end

@implementation FISAddMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.saveButton.accessibilityLabel = @"saveButton";
    self.messageContentField.accessibilityLabel = @"messageField";
}

- (IBAction)saveMessageButtonTapped:(id)sender {
    FISDataStore *store = [FISDataStore sharedDataStore];
    Message *newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:store.managedObjectContext];
    newMessage.content = self.messageContentField.text;
    newMessage.createdAt = [NSDate date];
    [store saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
