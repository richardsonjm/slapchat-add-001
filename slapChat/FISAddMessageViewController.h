//
//  FISAddMessageViewController.h
//  slapChat
//
//  Created by John Richardson on 7/13/16.
//  Copyright © 2016 Joe Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FISAddMessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

- (IBAction)saveMessageButton:(id)sender;
- (IBAction)cancelNewMessageButton:(id)sender;

@end
