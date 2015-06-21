//
//  CommentCellTableViewCell.m
//  Glimp
//
//  Created by Ahmed Salah on 11/27/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "CommentCellTableViewCell.h"

@implementation CommentCellTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CommentCellTableViewCell" owner:nil options:nil]
                lastObject];
        self.backgroundColor = [UIColor clearColor];
        self.userImage.layer.borderWidth = 0.4f;
        self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userImage.layer.masksToBounds = NO;
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
        self.userImage.clipsToBounds = YES;
        
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

- (IBAction)goToUser:(id)sender {
    [self.delegate didTappedAddfriendButtonAtCell:self];
}
@end
