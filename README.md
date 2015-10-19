
SlapChat
========
Let's make an app where you can create messages that persist in Core Data.
##Objectives
1. Set up core data model (`.xcdatamodeld`) from scratch.
2. Configure boilerplate code for data store to interact with Core Data / SQLite database.
3. Learn basics of creating new `NSManagedObject` subclasses.
4. Learn basics of fetching/saving with Core Data.

## Instructions
Open up the project. We've set up a blank tableview controller and started `FISDataManager`. Your job is to setup core data, display your persistent `FISMessage` objects, and add an interface where users can create and save new messages.

###Core Data Setup
Before we work on any views, we need to prepare our models for core data. 
This part has much more 'explaining' than 'coding', but it's important! So **soak up the knowledge.**

#####Data Model

1. First, let's create our data model (`.xcdatamodeld`). Create a new file, select the "Core Data" section on the left, then choose "Data Model". Usually we give this the same name as our project, so let's name it "slapChat".
- Go to your new **.xcdatamodeld** and create an entity (*"Add Entity" button near the bottom*) and name it `FISMessage`. Give it two attributes: `content` (String) and `createdAt` (Date).
- Now that we've set up the entity, we have to "generate the `NSManagedObject` subclass". 
   - In the top menu, go to Editor > Create NSManagedObject Subclass. Select "slapChat", then "FISMessage". 
   - When it asks you where you want to save the files, go to "Group" at the bottom to specify where they'll show up in your file navigator. 
- Voilà! You have 4 new files. The regular class (*FISMessage.h and .m*) is where you can write new methods. The category (*FISMessage+CoreDataProperties*) was made for Core Data so it can manage your object's properties— **don't mess with it!**

Our `.xcdatamodeld` is setup, so now let's setup `FISDataStore` so that it can fetch/save with Core Data. 

#####Data Store

1. Check out `FISDataStore.m`. We've set a few things up for you: singleton, `saveContext`, and a section titled `Core Data Stack` where the getter for an `NSManagedObjectContext` property is being overridden. Let's look at that getter.
   1. There's necessary boilerplate (read: boring, Apple-provided) code for linking an `NSManagedObjectContext` to your `.xcdatamodeld`, and we've thrown it in the getter for our context property. This is good because the context needs to be setup a particular way, and overriding the getter allows us to properly set it up whenever it may need.
   2. Notice that there are two auto-complete sections within this method. Enter the name of your .xcdatamodeld (`@"slapChat"`), linking your data model to a SQLite database. Read through the boilerplate and try to make sense of it.
3. We already setup `saveContext` because it's simply more boilerplate. Your task is to setup `fetchData`.
   - This is FISData*Store*, so add a public `NSArray` property to hold your fetched objects. Name it `messages`.
   - Implement `fetchData` to create an `NSFetchRequest`, have your context `execute` it, and set the results to your `messages` array.
 
That's it! Your model and data store are now ready to fetch and save `FISMessage`s.

###A Little More Setup

#####Making Test Messages

1. We can't display messages if we haven't created any! Let's do this in `FISTableViewController.m`.
    - Make a local array for storing messages. This will power your tableview's data source, and make it more self-contained.
	- Import and make your dataStore a property. In `viewDidLoad`, initialize it via the singleton method. 
	- Create a few `FISMessage`s. Remember, we can't just `alloc`/`init` them (*thanks, Core Data*)— use `+NSEntityDescription insertNewObjectForEntityForName:inManagedObjectContext:`. 
	- Don't forget to set your test messages' `content` and `createdAt` properties! 
2. So now is when you'd want to `saveContext` so that these messages would persist in our database. BUT— since this is in `viewDidLoad`, that means that we'll be creating and saving new messages *every time we run our app*. Let's add some logic to prevent that.
    - Make a new method called `generateTestData`. Dump all your message creation in there, and make your dataStore `saveContext` and `fetchData` at the end. 
    - In `viewDidLoad`, `fetchData` and then pass your dataStore's messages to your local messages array.
    - Logic time— `if`  your messages array is still empty, call `generateTestData` and pass them again.

3. Run it a couple times and either `NSLog` or breakpoint/`po` your local messages array to make sure you're not saving a ton of duplicates. Assuming all went well, we can finally get some stuff on the screen!

###View Time (Finally)
*Less talk; more walk.*

#####Messages TableView
- Set your cell reuse id and make it a basic cell.
- Set up your data source. Make each cell display the `content` of its corresponding message.

Run it to make sure it works. Comment out your `generateTestData` check to *prove* that the messages are actually persisting. Revel in your persistent data's glory. 

#####'Add Message' Interface
Let's keep rollin' with our theme of "just do it":

  1. Add a plus button to the navigation bar and link it to a new view controller. Name the class `FISAddMessageViewController`.
  2. Add a save button and a text field. When you tap save, make it:
     -  create a new message with the contents of the text field,
     -  save the context,
     -  dismiss the view controller.
  3. Cool! Except the new message didn't show up in our tableView... In your tableView controller, implement `viewWillAppear` so that it:     
     - fetches data, 
     - updates your local messages, 
     - reloads the tableView.   
  4. Give it another shot— when the AddMessageVC is dismissed, your tableView will display the new message.

####Congratulations, you made an app with a persistent data store!

## Extra Credit

  1. Add a button that resorts the messages in the array to descending by the `createdAt` property.
  2. Take your `generateTestData` method out of `FISTableViewController` and put it where it belongs (`FISDataStore`).
