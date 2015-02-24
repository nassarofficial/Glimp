//
//  FriendsTableViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 12/5/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *friends;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong)NSString *viewTitle;
@end
