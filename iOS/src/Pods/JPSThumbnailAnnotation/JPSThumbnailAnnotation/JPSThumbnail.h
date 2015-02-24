//
//  JPSThumbnail.h
//  JPSThumbnailAnnotation
//
//  Created by Jean-Pierre Simard on 4/22/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

typedef void (^ActionBlock)();

@interface JPSThumbnail : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) ActionBlock disclosureBlock;
@property(nonatomic, assign)int noOflikes;
@property(nonatomic, assign)int noOfComments;
@property(nonatomic, assign)int noOfViews;
@property(nonatomic, assign)BOOL isLiked;
@property(nonatomic, copy)NSString *videoUrl;
@property(nonatomic, copy)NSString *videoID;
@property(nonatomic, copy)NSString *videoImage;
@property(nonatomic, copy)NSString *userName;
@property(nonatomic, copy)NSString *videoLocation;
@property(nonatomic, copy)NSString *videoComment;
@property(nonatomic, copy)NSString *videoTime;
@property(nonatomic, copy)NSString *userID;

@end
