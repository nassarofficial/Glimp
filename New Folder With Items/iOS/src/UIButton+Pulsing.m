//
//  UIButton+Pulsing.m
//  Glimp
//
//  Created by Ahmed Salah on 10/17/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "UIButton+Pulsing.h"

@implementation UIButton (Pulsing)

-(void)startPulsing{
    [self stopPulsing];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:1.1];
    animation.repeatCount = HUGE_VAL;
    animation.duration = .4;
    animation.autoreverses = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addAnimation:animation forKey:@"pulse"];
}

-(void)stopPulsing{
    [self.layer removeAnimationForKey:@"pulse"];
}
@end
