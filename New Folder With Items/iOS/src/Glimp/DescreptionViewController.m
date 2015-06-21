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
