//
//  SearchViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 10/12/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreindsCell.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate,FriendsllDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectedFilter;
@property (strong, nonatomic)UIViewController *map;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic, strong)UserModel *user;
- (IBAction)searchButton:(id)sender;
@end
