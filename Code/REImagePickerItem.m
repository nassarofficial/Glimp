//
//  REImagePickerItem.m
//  TeacherKit
//
//  Created by Mourad on 8/21/13.
//  Copyright (c) 2013 ITWorx. All rights reserved.
//

#import "REImagePickerItem.h"
#import "REImagePickerCell.h"

@implementation REImagePickerItem

-(instancetype)initWithPesentingViewController:(UIViewController*) presentingViewController{
    self.viewController = presentingViewController;
    self = [super initWithTitle:@""];
    self.viewController = presentingViewController;
    self.cellHeight = 100;
    return self;
}

- (void) setCircledImage:(UIImage *)circledImage{

    _circledImage = circledImage;

    if (_circledImage) {
        [self.delegate didSelectImage:circledImage];
    }
    else{
        [self.delegate didClearImage];
    }
}

@end
