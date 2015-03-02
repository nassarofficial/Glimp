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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.navg.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"xx" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.movieView.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.avplayer play];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}


- (void)didReceiveMemoryWarning
{
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
        SBJSON* parser = [[SBJSON alloc] init];
        NSString *response = [parser stringWithObject:responseObject];
        NSDictionary* myDict = [parser objectWithString:response error:nil];
        if ([[[myDict objectForKey:@"SaveUserResult"] objectForKey:@"ErrorCode"] integerValue]== 0) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [SVProgressHUD showErrorWithStatus:[[myDict objectForKey:@"SaveUserResult"] objectForKey:@"ErrorMessage"]];
                           });
            
        }else{
            [SVProgressHUD dismiss];

        NSDictionary *userDict = [[myDict objectForKey:@"SaveUserResult"]objectForKey:@"ReturnedObject"];
        UserModel *user   = [[UserModel alloc]initWithData:userDict];
        [self saveUser:user];
        mapViewController *map = [[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
        map.user = user;
        [self.navigationController pushViewController:map animated:YES];
        }
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
