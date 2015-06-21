//
//  REImagePickerItem.h
//  TeacherKit
//
//  Created by Mourad on 8/21/13.
//  Copyright (c) 2013 ITWorx. All rights reserved.
//

#import "RETableViewItem.h"
@protocol REImagePickerItemDelegate
- (void) didSelectImage:(UIImage *)image;
@optional
- (void) didClearImage;
@end

@interface REImagePickerItem : RETableViewItem<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property (nonatomic,strong) NSNumber *imageSourceType;

@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) UIImage *circledImage;
@property (nonatomic,strong) NSData *imageData;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,assign) BOOL isCircular;
@property (nonatomic,assign) BOOL EnableClearOption;

@property (nonatomic,weak) id<REImagePickerItemDelegate> delegate;
@property (nonatomic,assign) BOOL isContextColored;

@property (nonatomic,assign) UIViewController *viewController;

/**
 *  Allocates and Initializes the RECircledImagePickerItem the view controller which composes it
 *
 *  @param presentingViewController The view controller which composes the item and which will present Picker Controllers
 *
 *  @return self
 */
//-(instancetype)initWithPesentingViewController:(UIViewController*) presentingViewController andImageSourceType:(NSNumber*)type;
-(instancetype)initWithPesentingViewController:(UIViewController*) presentingViewController;


@end
