//
//  ForgotPasswordViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 2/23/15.
//  Copyright (c) 2015 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
- (IBAction)resetPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end
