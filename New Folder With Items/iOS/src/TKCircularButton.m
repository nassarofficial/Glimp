//
//  TKCircularButton.m
//  TeacherKit
//
//  Created by Amr Elsehemy on 8/16/13.
//  Copyright (c) 2013 ITWorx. All rights reserved.
//

#import "TKCircularButton.h"

@implementation TKCircularButton

-(void)baseInit{

    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width / 2;
//    self.layer.borderWidth = 1.5;
//    self.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
//    [self setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [self.titleLabel setNumberOfLines:2];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self baseInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self baseInit];
    }

    return self;
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    self.layer.borderWidth = image == nil ? 1 : 0;
    [super setImage:image forState:state];
}

@end
