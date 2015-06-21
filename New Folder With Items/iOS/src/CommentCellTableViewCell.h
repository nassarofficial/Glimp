//
//  CommentCellTableViewCell.h
//  Glimp
//
//  Created by Ahmed Salah on 11/27/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentCellTableViewCell;
@protocol commentCellDelegate
- (void) didTappedAddfriendButtonAtCell:(CommentCellTableViewCell *)cell;
@end

@interface CommentCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
- (IBAction)goToUser:(id)sender;
@property (weak, nonatomic) id<commentCellDelegate> delegate;

@end
