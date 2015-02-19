//
//  LoginViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 9/6/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "LoginViewController.h"
#import "VerificationCodeViewController.h"
#import "LeveyPopListView.h"
#import "NSObject+SBJSON.h"
#import "mapViewController.h"
#import "ForGetMyPasswordViewController.h"

@interface LoginViewController (){
    UITapGestureRecognizer *tap;
    UserModel *user;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    user = [[UserModel alloc]init];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"LOG IN";
    tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view  addGestureRecognizer:tap];
    self.navigationItem.hidesBackButton = YES;
    [self customizeBackButton];
    // Do any additional setup after loading the view from its nib.
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signIn:(id)sender {
    if (self.userNameTextField.text.length != 0 && self.passwordTextField.text.length != 0) {
    [SVProgressHUD showWithStatus:@"logging In"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:self.userNameTextField.text forKey:@"userName"];
    [parameters setObject:self.passwordTextField.text forKey:@"password"];

    [NSURLSessionConfiguration defaultSessionConfiguration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:KHostURL,KRegisterURL];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
     
        mapViewController *mapView = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
        
        mapView.user = user;

        [self.navigationController pushViewController:mapView animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error while loggin in "];
    }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"Please enter a Valid user name and password"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(0, -100, 320, [[UIScreen mainScreen] bounds].size.height)];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    [UIView commitAnimations];
    return YES;
}


- (IBAction)goToForgetPassword:(id)sender {
    ForGetMyPasswordViewController *forgetpassword = [[ForGetMyPasswordViewController alloc]initWithNibName:@"ForGetMyPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgetpassword animated:YES];
}


@end
