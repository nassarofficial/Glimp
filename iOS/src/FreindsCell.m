//
//  FreindsCell.m
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "FreindsCell.h"

@implementation FreindsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FreindsCell" owner:nil options:nil]
                lastObject];
        self.backgroundColor = [UIColor clearColor];
        self.contactImage.layer.borderWidth = 1.0f;
        self.contactImage.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contactImage.layer.masksToBounds = NO;
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width / 2;
        self.contactImage.clipsToBounds = YES;
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addFriend:(id)sender {
    UIButton *btn = (UIButton *)sender;

    [self.delegate didTappedAddfriendButtonAtCell:self type:btn];
}
@end
