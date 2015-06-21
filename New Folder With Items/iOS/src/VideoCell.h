//
//  VideoCell.h
//  Glimp
//
//  Created by Ahmed Salah on 11/25/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoCell;
@protocol videoCellDelegate
- (void) didTappedAddCommentButtonAtCell:(VideoCell *)cell ;
@end
@interface VideoCell : UITableViewCell
@property (weak, nonatomic) id<videoCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *liveImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *Location;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *noOfViews;
@property (weak, nonatomic) IBOutlet UILabel *noOfComments;

@end
