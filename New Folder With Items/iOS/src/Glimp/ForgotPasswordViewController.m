//
//  ForgotPasswordViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 2/23/15.
//  Copyright (c) 2015 Ahmed Salah. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)resetPassword:(id)sender {
    if (self.emailTextField.text.length != 0 && self.userNameTextField.text.length != 0) {
        [SVProgressHUD showWithStatus:@"Reset Your Password"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters =  [NSMutableDictionary new];
        [parameters setObject:self.userNameTextField.text forKey:@"userName"];
        [parameters setObject:self.emailTextField.text forKey:@"email"];
        
        [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSString *url = [NSString stringWithFormat:KHostURL,KRegisterURL];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            SBJSON* parser = [[SBJSON alloc] init];
            NSString *response = [parser stringWithObject:responseObject];
            NSDictionary* myDict = [parser objectWithString:response error:nil];
   
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:@"error while loggin in "];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"Please enter a Valid user name and password"];
    }
}

@end
