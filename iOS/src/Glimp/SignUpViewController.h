//
//  SingUpViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 2/9/15.
//  Copyright (c) 2015 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic, weak) IBOutlet UIView *movieView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)signUp:(id)sender;

@end
