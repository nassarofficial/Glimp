//
//  EditProfileViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 9/27/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableViewCell.h"
#import "ContactsViewController.h"
#import "FreindsCell.h"
#import "EditProfileViewController2.h"
#import "mapViewController.h"

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *noOfVideos;
@property (weak, nonatomic) IBOutlet UIButton *follow;
- (IBAction)getUserVideos:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *followingsButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign)BOOL fromSearch;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign)BOOL myProfile;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)followingsUsers:(id)sender;
- (IBAction)followersUsers:(id)sender;
- (IBAction)followAction:(id)sender;

@end
