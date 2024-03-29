//
//  AppDelegate.h
//  InTownApp
//
//  Created by Ronald Hernandez on 9/5/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property User *selectedUser;
@property User *selectedRecepient;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

