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

#import <CoreData/CoreData.h>

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

SpecBegin(FISAddMessageViewController)

describe(@"FISAddMessageViewController", ^{
    
    __block NSManagedObjectContext *moContext;
    __block NSString *messageEntity;
    __block FISDataStore *dataStore;
    
    beforeAll(^{
        // this could be a class method in a helper class that returns a MOC
//        NSManagedObjectModel *moModel = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
        
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
