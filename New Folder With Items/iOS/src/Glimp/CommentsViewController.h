//
//  CommentsViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 11/26/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFComposeBarView.h"

@interface CommentsViewController : UIViewController<PHFComposeBarViewDelegate>


@property (nonatomic, retain)IBOutlet UIView *viewTable;

@property (nonatomic, retain)IBOutlet UIView *viewForm;
@property(nonatomic ,strong)NSString *videoID;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)IBOutlet UIButton *chatButton;
@property (nonatomic, strong)UserModel *user;

@end
