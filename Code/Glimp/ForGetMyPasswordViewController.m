//
//  ForGetMyPasswordViewController.m
//  Glimp
//
//  Created by nassar on 2/18/15.
//  Copyright (c) 2015 Ahmed Salah. All rights reserved.
//
#import "AppDelegate.h"
#import "mapViewController.h"
#import "ForGetMyPasswordViewController.h"

@interface ForGetMyPasswordViewController ()

@end

@implementation ForGetMyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)customizeBackButton{
    UIView *btnVu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44,44)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(goBack)
     forControlEvents:UIControlEventTouchDown];
    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setContentMode:UIViewContentModeCenter];
    [button setImage:[UIImage imageNamed:@"whitearrow"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [btnVu addSubview:button];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnVu]];
    
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
