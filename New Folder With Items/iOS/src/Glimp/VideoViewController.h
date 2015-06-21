//
//  VideoViewController.h
//  Glimp
//
//  Created by Ahmed Salah on 11/25/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface VideoViewController : UIViewController
- (IBAction)DoneAction:(id)sender;
@property(nonatomic, strong)VideoModel *currentVideo;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@end
