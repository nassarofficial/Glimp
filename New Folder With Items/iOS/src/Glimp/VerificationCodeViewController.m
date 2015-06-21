//
//  VerificationCodeViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "VerificationCodeViewController.h"
#import "ContactsViewController.h"
#import "EditProfileViewController2.h"
#import "mapViewController.h"
#import "AppDelegate.h"
@interface VerificationCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *virificationTextField;

@end

@implementation VerificationCodeViewController

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
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sendVerificationCode:(id)sender {
   if ([self.verficationCode isEqualToString:self.verificationTextField.text]) {
       [SVProgressHUD showWithStatus:@"Checking your code .."];
       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       NSMutableDictionary *parameters =  [NSMutableDictionary new];
       [parameters setObject:self.user.countryName forKey:@"country"];
       [parameters setObject:self.user.mobileNo forKey:@"mobile"];
       [NSURLSessionConfiguration defaultSessionConfiguration];
       manager.requestSerializer = [AFJSONRequestSerializer serializer];
       manager.responseSerializer = [AFJSONResponseSerializer serializer];
       NSString *url = [NSString stringWithFormat:KHostURL,KIsNewUser];
       [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [SVProgressHUD dismiss];
           SBJSON* parser = [[SBJSON alloc] init];
           NSString *response = [parser stringWithObject:responseObject];
           NSDictionary* myDict = [parser objectWithString:response error:nil];
           if ([[[myDict objectForKey:@"IsNewUserResult"] objectForKey:@"ErrorCode"] integerValue] == 0) {
               EditProfileViewController2 *editProfile = [[EditProfileViewController2 alloc]init];
               editProfile.user = self.user;
               [self.navigationController pushViewController:editProfile animated:YES];
           }else if([[[myDict objectForKey:@"IsNewUserResult"] objectForKey:@"ErrorCode"] integerValue] == 1){
               NSDictionary *userDic =[[myDict objectForKey:@"IsNewUserResult"] objectForKey:@"ReturnedObject"];
               UserModel *user = [[UserModel alloc]initWithData:userDic];
               [self saveUser:user];
               [self goToMap:user];
               
           }
               
 
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
           [SVProgressHUD showErrorWithStatus:@"error"];
       }];

   }else{
       self.verificationTextField.text = nil;
        [SVProgressHUD showErrorWithStatus:@"Please enter a valid message"];
   }

}
-(void)saveUser:(UserModel *)user{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)goToMap:(UserModel*)user{

    mapViewController *map = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
    map.user = user;

    [self.navigationController pushViewController:map animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
