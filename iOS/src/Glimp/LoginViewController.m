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
#import "AppDelegate.h"
#import "ForgotPasswordViewController.h"
@interface LoginViewController (){
    UITapGestureRecognizer *tap;
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.navg.navigationBarHidden = NO;
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
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        if ([[[myDict objectForKey:@"LoginResult"] objectForKey:@"ErrorCode"] integerValue]== 0) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [SVProgressHUD showErrorWithStatus:[[myDict objectForKey:@"LoginResult"] objectForKey:@"ErrorMessage"]];
                           });
         
        }else{
        NSDictionary *userDict = [[myDict objectForKey:@"LoginResult"]objectForKey:@"ReturnedObject"];
        UserModel *user   = [[UserModel alloc]initWithData:userDict];
        [self saveUser:user];
        mapViewController *mapView = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
        
        mapView.user = user;
        [SVProgressHUD dismiss];

        [self.navigationController pushViewController:mapView animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error while loggin in "];
    }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"Please enter a Valid user name and password"];
    }
}
- (IBAction)fogotPassword:(id)sender{
    ForgotPasswordViewController *forgot = [[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgot animated:YES];
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

-(void)saveUser:(UserModel *)user{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
