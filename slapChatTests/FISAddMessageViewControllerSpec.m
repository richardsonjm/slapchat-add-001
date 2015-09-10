//
//  FISAddMessageViewControllerSpec.m
//  slapChat
//
//  Created by Tom OMalley on 9/9/15.
//  Copyright 2015 Joe Burgess. All rights reserved.
//

#import "FISAddMessageViewController.h"
#import "Message.h"
#import "FISDataStore.h"
#import "FISAppDelegate.h"

#import <CoreData/CoreData.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <KIF/KIF.h>

SpecBegin(FISAddMessageViewController)

describe(@"FISAddMessageViewController", ^{
    
    __block NSManagedObjectContext *moContext;
    __block NSString *messageEntity;
    __block FISDataStore *dataStore;
    __block NSArray *originalSavedMessages;
    __block FISAddMessageViewController *addMessageVC;
    
    __block UITextField *messageField;
    __block NSString *messageFieldAccessLabel;
    __block UIButton *saveButton;
    __block NSString *saveButtonAccessLabel;
    
    beforeAll(^{
        // this could be a class method in a helper class that returns a MOC
        NSManagedObjectModel *moModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: moModel];
        
        [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        
        moContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
        [moContext setPersistentStoreCoordinator: persistentStoreCoordinator];
        
        dataStore = [FISDataStore sharedDataStore];
        [dataStore setValue:moContext forKey:@"_managedObjectContext"];
        dataStore.messages = nil;

        // you have fetch/save here cause of (if count == 0 generateTestData) clause written into fetchData
        [dataStore fetchData];
        [dataStore saveContext];
        originalSavedMessages = dataStore.messages;

        // now our in memory MOContext is setup, and the VC's wont mess it up if they 'fetchData'
            // another solution would be to swizzle out the generateTestData method ...
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        addMessageVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"addMessageVC"];
        [window setRootViewController: addMessageVC];
        [window makeKeyAndVisible];
        
        messageEntity = @"Message";
        
        messageFieldAccessLabel = @"messageField";
        messageField = (UITextField*)[tester waitForViewWithAccessibilityLabel: messageFieldAccessLabel];

        saveButtonAccessLabel = @"saveButton";
        saveButton = (UIButton*)[tester waitForViewWithAccessibilityLabel: saveButtonAccessLabel];
    });
    
    describe(@"messageField", ^{

        it(@"is accessible via accessibilityLabel", ^{
            expect(messageField).toNot.beNil();
        });
        
        it(@"has userInteractionEnabled", ^{
            expect(messageField.userInteractionEnabled).to.beTruthy();
        });
        
        it(@"is editable", ^{
            NSString *testMessage = @"test message";
            [tester enterText:testMessage intoViewWithAccessibilityLabel: messageFieldAccessLabel];
            expect(messageField.text).to.equal(testMessage);
        });
        
        afterAll(^{
            [tester clearTextFromViewWithAccessibilityLabel:messageFieldAccessLabel];
        });
    });
    
    describe(@"saveButton", ^{
        
        it(@"is accessible via accessibilityLabel", ^{
            expect(saveButton).toNot.beNil();
        });
        
        it(@"has userInteractionEnabled", ^{
            expect(saveButton.userInteractionEnabled).to.beTruthy();
        });
    });
    
    it(@"can save a message to the dataStore", ^{
        NSString *testMessage = @"test message";
        [tester enterText: testMessage intoViewWithAccessibilityLabel: messageFieldAccessLabel];
        [tester tapViewWithAccessibilityLabel: saveButtonAccessLabel];
        [tester waitForTimeInterval:0.5];
        [dataStore fetchData];
        Message *newlyAddedMessage = [dataStore.messages lastObject];
        expect(newlyAddedMessage.content).to.equal(testMessage);
    });
});

SpecEnd
