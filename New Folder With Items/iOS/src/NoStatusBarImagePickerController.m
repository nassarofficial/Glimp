//
//  NoStatusBarImagePickerController.m
//  TeacherKit
//
//  Created by Mourad on 3/11/14.
//  Copyright (c) 2014 ITWorx. All rights reserved.
//

#import "NoStatusBarImagePickerController.h"

@implementation NoStatusBarImagePickerController

- (BOOL)prefersStatusBarHidden {
    return (self.sourceType == UIImagePickerControllerSourceTypeCamera);
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

@end
