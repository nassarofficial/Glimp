//
//  AppDelegate.h
//  Glimp
//
//  Created by Ahmed Salah on 9/6/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain, nonatomic) UIViewController *viewController;
@property (retain, nonatomic) UINavigationController *navg ;
@property (strong, nonatomic) UITabBarController *tabbar ;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
