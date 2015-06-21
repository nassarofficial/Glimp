//
//  VideoViewController.m
//  Glimp
//
//  Created by Ahmed Salah on 11/25/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController ()
{
    MPMoviePlayerController *theMoviPlayer;
}
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.videoImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentVideo.videoImage]] placeholderImage:[UIImage imageNamed:@"play"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self.videoImage setImage:image];
        [self.videoImage setContentMode:UIViewContentModeScaleToFill];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self.videoImage setContentMode:UIViewContentModeCenter];
    } ];
    [self.videoImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(playAvideoWithFrame)] ;
    singleTap.numberOfTapsRequired = 1;
    [self.videoImage addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)playAvideoWithFrame{
    NSURL *urlString=[NSURL URLWithString:self.currentVideo.videoUrl];
    theMoviPlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlString];
    [theMoviPlayer prepareToPlay];
    theMoviPlayer.scalingMode = MPMovieScalingModeAspectFill;
    theMoviPlayer.movieSourceType = MPMovieSourceTypeStreaming;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    [theMoviPlayer setFullscreen:YES animated:YES];
    theMoviPlayer.view.frame = self.view.frame;
    [self.view addSubview:theMoviPlayer.view];
    [theMoviPlayer setFullscreen:YES animated:YES];
}
- (void)willEnterFullscreen:(NSNotification*)notification {
}

- (void)enteredFullscreen:(NSNotification*)notification {
}

- (void)willExitFullscreen:(NSNotification*)notification {
}

- (void)exitedFullscreen:(NSNotification*)notification {
    [UIView animateWithDuration:2.0f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|!UIViewAnimationOptionAllowUserInteraction animations:^{
        [theMoviPlayer.view setAlpha:0];
        
    } completion:^(BOOL finished) {
        [theMoviPlayer.view removeFromSuperview];
        theMoviPlayer = nil;
        
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification*)notification {
    [UIView animateWithDuration:0.6f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|!UIViewAnimationOptionAllowUserInteraction animations:^{
        [theMoviPlayer.view setAlpha:0];
        
    } completion:^(BOOL finished) {
        [theMoviPlayer setFullscreen:NO animated:YES];
        
    }];
}

- (IBAction)DoneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
