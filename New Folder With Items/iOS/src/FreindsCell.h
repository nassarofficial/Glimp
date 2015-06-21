//
//  FreindsCell.h
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FreindsCell;
@protocol FriendsllDelegate
- (void) didTappedAddfriendButtonAtCell:(FreindsCell *)cell type:(UIButton *)button ;
@end
@interface FreindsCell : UITableViewCell
@property (weak, nonatomic) id<FriendsllDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)addFriend:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end
