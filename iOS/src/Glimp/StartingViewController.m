//
//  StartingViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 2/8/15.
//  Copyright (c) 2015 Ahmed Salah. All rights reserved.
//

#import "StartingViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "mapViewController.h"
#import <AVFoundation/AVFoundation.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface StartingViewController ()
@property (nonatomic, strong) AVPlayer *avplayer;
@property (strong, nonatomic) IBOutlet UIView *movieView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation StartingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Not affecting background music playing
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
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
    
    //Config dark gradient view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[UIScreen mainScreen] bounds];
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x030303) CGColor], (id)[[UIColor clearColor] CGColor], (id)[UIColorFromRGB(0x030303) CGColor],nil];
    [self.gradientView.layer insertSublayer:gradient atIndex:0];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = YES;

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

- (IBAction)loginFacebook:(id)sender {
    [SCFacebook loginCallBack:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dic = result;
            [SVProgressHUD showWithStatus:@"Saving Your info."];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSMutableDictionary *parameters =  [NSMutableDictionary new];
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];

            [parameters setObject:@"" forKey:@"image"];
            [parameters setObject:[dic objectForKey:@"first_name" ] forKey:@"firstName"];
            [parameters setObject:[dic objectForKey:@"last_name" ] forKey:@"lastName"];
            [parameters setObject:[dic objectForKey:@"email" ] forKey:@"email"];
            [parameters setObject:[dic objectForKey:@"name"] forKey:@"userName"];
            [parameters setObject:@""forKey:@"countryCode"];
            [parameters setObject:@"" forKey:@"countryName"];
            [parameters setObject:@"" forKey:@"mobileNo"];
            [parameters setObject:@"1" forKey:@"gender"];
            [parameters setObject:[dic objectForKey:@"accessToken"] forKey:@"password"];
            [parameters setObject:@""forKey:@"birthDate"];

            [parameters setObject:[NSNumber numberWithBool:YES]forKey:@"isFacebookUser"];
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
    }];

}

-(void)saveUser:(UserModel *)user{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (IBAction)goToSignIn:(id)sender {
    LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:login animated:YES];
}

- (IBAction)goToSignUp:(id)sender {
    SignUpViewController *signup = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:signup animated:YES];
}
@end
