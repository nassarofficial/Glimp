//
//  Annotation.h
//  CoreLocation2
//
//  Created by Ahmed Salah on 5/16/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "QTreeInsertable.h"

@interface Annotation : NSObject<MKAnnotation, QTreeInsertable>
@property(nonatomic, assign)CLLocationCoordinate2D coordinate;
@property(nonatomic, assign)int noOflikes;
@property(nonatomic, assign)BOOL isLiked;
@property(nonatomic, copy)NSString *videoUrl;
@property(nonatomic, copy)NSString *videoID;
@property(nonatomic, copy)NSString *Image;
@property(nonatomic, copy)NSString *annotationImage;
@property(nonatomic, copy)NSString *userName;
@property(nonatomic, copy)NSString *videoComment;
- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
@end
