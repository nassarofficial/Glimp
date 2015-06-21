//
//  TableViewCell.m
//  Glimp
//
//  Created by Ahmed Salah on 9/27/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewCell" owner:nil options:nil]
                lastObject];
        self.backgroundColor = [UIColor clearColor];
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
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.delegate getText:self];
}



@end
