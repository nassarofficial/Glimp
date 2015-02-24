//
//  EditProfileViewController2.h
//  Glimp
//
//  Created by Ahmed Salah on 9/30/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RETableViewManager/RETableViewManager.h>
#import "NSObject+SBJSON.h"
@interface EditProfileViewController2 : UITableViewController
@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign) BOOL fromMap;
@end
