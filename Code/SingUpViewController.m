//
//  SingUpViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 2/9/15.
//  Copyright (c) 2015 Ahmed Salah. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
#import "mapViewController.h"
@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    self.title= @"SIGN UP";
    [self.view  addGestureRecognizer:tap];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;

    [self customizeBackButton];
}
-(void)hideKeyboard:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];

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

- (IBAction)signUp:(id)sender {
    if ([self verifyTextFields]) {
        
    [SVProgressHUD showWithStatus:@"Saving Your info."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    [parameters setObject:@"" forKey:@"image"];
    [parameters setObject:@"" forKey:@"firstName"];
    [parameters setObject:@"" forKey:@"lastName"];
    [parameters setObject:self.emailTextField.text forKey:@"email"];
    [parameters setObject:self.userNameTextField.text forKey:@"userName"];
    [parameters setObject:@""forKey:@"countryCode"];
    [parameters setObject:@"" forKey:@"countryName"];
    [parameters setObject:self.phoneNoTextField.text forKey:@"mobileNo"];
    [parameters setObject:@"1" forKey:@"gender"];
    [parameters setObject:self.passwordTextField.text forKey:@"password"];
    [parameters setObject:@""forKey:@"birthDate"];
    [parameters setObject:deviceToken?deviceToken:@"" forKey:@"deviceToken"];
    
    [NSURLSessionConfiguration defaultSessionConfiguration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:KHostURL,KSaveUser];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        NSDictionary *userDict = [[myDict objectForKey:@"SaveUserResult"]objectForKey:@"ReturnedObject"];
        UserModel *user   = [[UserModel alloc]initWithData:userDict];
        [self saveUser:user];
        mapViewController *map = [[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
        map.user = user;
        [self.navigationController pushViewController:map animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error while saving your profile "];
    }];
    }

}
-(BOOL)verifyTextFields{
    if (self.userNameTextField.text.length != 0 && self.passwordTextField.text.length != 0 && self.emailTextField.text.length != 0 && self.phoneNoTextField.text.length != 0) {
        return YES;
    }else{
        [SVProgressHUD showErrorWithStatus:@"Please enter all fields to sign up"];
        return NO;

    }
}

-(void)saveUser:(UserModel *)user{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
@end
