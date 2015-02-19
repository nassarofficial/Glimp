//
//  DescreptionViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 12/6/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "DescreptionViewController.h"

@interface DescreptionViewController ()


@property (weak, nonatomic) IBOutlet UITextView *descreptionTextField;

@end

@implementation DescreptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url =[NSURL URLWithString:self.stringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    UIView *homeBtnVu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self
            action:@selector(openMenu)
  forControlEvents:UIControlEventTouchDown];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(-10, 0, 44, 44)];
    [homeBtnVu addSubview:btn];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:homeBtnVu];
}
-(void)openMenu{
    
    [self.viewDeckController openLeftViewAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
