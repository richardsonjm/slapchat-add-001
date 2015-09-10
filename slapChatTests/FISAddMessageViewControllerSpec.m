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
    

    __block UINavigationController *navController;
    
    beforeAll(^{
        // this could be a class method in a helper class that returns a MOC
        NSManagedObjectModel *moModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: moModel];
        
        [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        
        moContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [moContext setPersistentStoreCoordinator: persistentStoreCoordinator];
        
        messageEntity = @"Message";
        dataStore = [FISDataStore sharedDataStore];
        [dataStore setValue:moContext forKey:@"_managedObjectContext"];
        dataStore.messages = nil;
        
        // you cant save/fetch here, cause of the "generateTestData" clause
        // thats written into the dataStore's "fetchData". (if count == 0 generateTestData)
        // SO, you have to save/fetch AFTER you save something so it doesnt auto make stuff
        
        // a solution would be to swizzle out the generateTestData method ...
        // OR swizzle out the [FISDataStore sharedDataStore] method to return a testDataStore class or something.
        
        // another thought is to write tests knowing that generateTestData happens.
        // get a count of the items with a fresh MOC and save/fetch, then run all tests (number wise) against that original count like expect(count)toEqual(originalCount+1)
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navController = [mainStoryboard instantiateInitialViewController];
//        FISTableViewController *mainTVC = navController.visibleViewController;
        window.rootViewController = navController;
        [window makeKeyAndVisible];
        
        // !!! putting the VC on the screen messes all the coredata stuff up
        // looks like if we want to test the "app" (which is really only making sure it does the rudimentary bs of
        // add button segues and VC can be dismissed) we have to swizzle out the method or datastore entirely.
        
        // makes me feel like we should just ignore the view stuff and do as much in the background as possible.
        // however, in more complicated ones, we'll have to figure out a way around this.
        
        // oh i guess we could also do that idea where we just rely on it having 3 objects from the start...
    });
    
    it(@"is accessible via addButton with accessibilityLabel", ^{
        // is this actually necessary?
        // at this stage of the program, should we still be testing for things like this? // EDIT see !!! above
        [tester tapViewWithAccessibilityLabel:@"addButton"];
        [tester waitForAbsenceOfViewWithAccessibilityLabel:@"mainTableView"];
        expect(navController.visibleViewController).to.beMemberOf([FISAddMessageViewController class]);
    });
    
    it(@"can add a message to the context", ^{
        expect(dataStore.messages.count).to.equal(0);

        Message *newMessage = [NSEntityDescription insertNewObjectForEntityForName:messageEntity inManagedObjectContext: moContext];
        
        [dataStore saveContext];
        [dataStore fetchData];
        
        expect(dataStore.messages.count).to.equal(1);
        expect(dataStore.messages).to.equal(@[newMessage]);
    });  
    
    afterEach(^{

    });
    
    afterAll(^{

    });
});

SpecEnd
