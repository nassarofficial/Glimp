//
//  EditProfileViewController2.m
//  Glimp
//
//  Created by Ahmed Salah on 9/30/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "EditProfileViewController2.h"
#import <RETableViewManager/RETextItem.h>
#import "ReCustomTextItem.h"
#import <REPickerItem.h>
#import "REImagePickerItem.h"
#import "ContactsViewController.h"
#import "mapViewController.h"
@interface EditProfileViewController2 ()<REImagePickerItemDelegate, RETableViewManagerDelegate>{
    REImagePickerItem *imageItem;
    ReCustomTextItem *firstNameItem, *lastNameItem, *userNameItem, *emailNameItem;
    REPickerItem *picker;
    NSMutableArray *byteArray;
}
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *mobileNo;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *gender;

@end

@implementation EditProfileViewController2

- (void)loadTableView
{
    RETableViewSection *section = [RETableViewSection  section];
    imageItem =[[REImagePickerItem alloc]initWithPesentingViewController:self];
    imageItem.delegate = self;
    [section addItem:imageItem];
    __block EditProfileViewController2 *blockSelf = self;
    userNameItem = [[ReCustomTextItem alloc] initWithTitle:nil value:nil placeholder:@"User Name"];
    userNameItem.onEndEditing = ^(RETextItem *item){
        blockSelf.userName = item.value;
    };
    [section addItem:userNameItem];
    
    lastNameItem = [[ReCustomTextItem alloc] initWithTitle:nil value:nil placeholder:@"Mobile No."];
    
    lastNameItem.onEndEditing = ^(RETextItem *item){
        blockSelf.mobileNo = item.value;
    };
    [section addItem:lastNameItem];
  
    emailNameItem = [[ReCustomTextItem alloc] initWithTitle:nil value:nil placeholder:@"Email"];
    emailNameItem.onEndEditing = ^(RETextItem *item){
        blockSelf.email = item.value;

    };
    [section addItem:emailNameItem];
    
    [self.manager addSection:section];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavigationBar];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"blurry"];
    self.tableView.backgroundView = imageView;
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self loadTableView];
   
    if (self.fromMap) {
        self.navigationItem.hidesBackButton = NO;
        self.user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
        if (self.user) {
            [self loadProfile];
        }

    }else
        self.navigationItem.hidesBackButton = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" Back" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popToRootViewControllerAnimated:)];


}
-(void)loadProfile{
   
    if (self.user.lastName) {
        self.mobileNo = self.user.mobileNo;
        lastNameItem.value = self.user.mobileNo;
    }
    if (self.user.userName) {
        self.userName = self.user.userName;
        userNameItem.value = self.user.userName;
    }
    if (self.user.email) {
        self.email = self.user.email;
        emailNameItem.value = self.user.email;
    }

    
    if ([self.user.gender intValue] == 1)
        [picker setValue:@[@"Male"]];
    else
        [picker setValue:@[@"Female"]];
    if (self.user.imageUrl)  {
        UIImageView *tempImage = [[UIImageView alloc]init];
        [tempImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.user.imageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageItem.circledImage = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];

    }
    
}
-(void)customizeNavigationBar{
    self.title = @"Edit Profile";
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:RGB(71,71,71)];
    UIView *homeBtnVu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self
            action:@selector(submitAction)
  forControlEvents:UIControlEventTouchDown];
    [btn setTitle:@"submit" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(-10, 0, 80, 44)];
    [homeBtnVu addSubview:btn];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:homeBtnVu];
    

}
-(void)submitAction{
    
    [SVProgressHUD showWithStatus:@"Saving Your info."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.user.UserName = self.userName;
    self.user.mobileNo = self.mobileNo;
    self.user.Email = self.email;
    self.user.FirstName = self.firstName;
    self.user.deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:byteArray?byteArray:@"" forKey:@"image"];
    [parameters setObject:self.firstName?self.firstName:@"" forKey:@"firstName"];
    [parameters setObject:self.user.lastName?self.user.lastName:@"" forKey:@"lastName"];
    [parameters setObject:self.email?self.email:@"" forKey:@"email"];
    [parameters setObject:self.userName?self.userName:@"" forKey:@"userName"];
    [parameters setObject:self.user.countryCode?self.user.countryCode:@"" forKey:@"countryCode"];
    [parameters setObject:self.user.countryName?self.user.countryName:@"" forKey:@"countryName"];
    [parameters setObject:self.mobileNo?self.mobileNo:@"" forKey:@"mobileNo"];
    [parameters setObject:self.user.gender?self.user.gender:@"1" forKey:@"gender"];
    [parameters setObject:@""forKey:@"password"];
    [parameters setObject:@""forKey:@"birthDate"];
    [parameters setObject:self.user.deviceToken?self.user.deviceToken:@"" forKey:@"deviceToken"];

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
        [SVProgressHUD showSuccessWithStatus:@""];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"error while saving your profile "];
    }];

    
}
-(void)saveUser:(UserModel *)user{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void) didSelectImage:(UIImage *)image{
    NSData *imageData  = UIImageJPEGRepresentation(image, 0.0);
    const unsigned char *bytes = [imageData bytes]; // no need to copy the data
    NSUInteger length = [imageData length];
    byteArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++) {
        [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
    }

}
@end
