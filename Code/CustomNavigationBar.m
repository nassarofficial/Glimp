//
//  CustomNavigationBar.m
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setTranslucent:YES];
        NSShadow *shadow = [NSShadow new];
        [shadow setShadowColor: [UIColor clearColor]];
        [shadow setShadowOffset: CGSizeMake(0.0f, 1.0f)];
        [self setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor clearColor], NSShadowAttributeName: shadow}];
        [self setBarStyle:UIBarStyleBlack];
        [self setBarTintColor:[UIColor blueColor ]];
    
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 320, 1)];
        [view setBackgroundColor:RGB(177, 159, 145)];
        [self addSubview:view];
        UIView *statusBarView = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
        [statusBarView setBackgroundColor:[UIColor blackColor]];
        
        
    }
    return self;
}

//for custom size of the UINavigationBar
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(320, 36);
}

@end
