//
//  VideoCell.m
//  Glimp
//
//  Created by Ahmed Salah on 11/25/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:nil options:nil]
                lastObject];
        self.liveImage.layer.borderWidth = 1.0f;
        self.liveImage.layer.borderColor = [UIColor whiteColor].CGColor;
        self.liveImage.layer.masksToBounds = NO;
        self.liveImage.layer.cornerRadius = self.liveImage.frame.size.width / 2;
        self.liveImage.clipsToBounds = YES;
        [self.comment setAdjustsFontSizeToFitWidth:YES];
        UITapGestureRecognizer *singleTapForPlaces = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(showComments)] ;
        singleTapForPlaces.numberOfTapsRequired = 1;
        [self.commentImage addGestureRecognizer:singleTapForPlaces];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showComments{
    [self.delegate didTappedAddCommentButtonAtCell:self];
}
@end
