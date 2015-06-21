//
//  VerificationCodeViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 9/13/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationCodeViewController : UIViewController
@property (nonatomic, strong)UserModel *user;
@property (nonatomic, strong)NSString  *verficationCode;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@end
