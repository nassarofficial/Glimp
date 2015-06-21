//
//  ContactsViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "FreindsCell.h"
@interface ContactsViewController : UIViewController<FriendsllDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *skip;
@property (nonatomic, strong)UserModel *user;
- (IBAction)skipAction:(id)sender;

@end
