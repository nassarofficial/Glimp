//
//  SingUpViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 2/9/15.
//  Copyright (c) 2015 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
- (IBAction)signUp:(id)sender;

@end
