//
//  TableViewCell.h
//  Glimp
//
//  Created by Ahmed Salah on 9/27/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileTableViewCell;
@protocol editProfileCellDelegate
- (void) getText:(ProfileTableViewCell *)cell;
@end

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) id<editProfileCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
