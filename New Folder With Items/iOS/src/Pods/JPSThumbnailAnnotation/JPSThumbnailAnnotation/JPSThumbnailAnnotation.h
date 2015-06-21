//
//  JPSThumbnailAnnotation.h
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

@import Foundation;
@import MapKit;
#import "JPSThumbnail.h"
#import "JPSThumbnailAnnotationView.h"

@protocol JPSThumbnailAnnotationProtocol <NSObject>

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;

@end

@interface JPSThumbnailAnnotation : NSObject <MKAnnotation, JPSThumbnailAnnotationProtocol>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, assign)int noOflikes;
@property(nonatomic, assign)int noOfComments;
@property(nonatomic, assign)int noOfViews;
@property(nonatomic, assign)BOOL isLiked;
@property(nonatomic, copy)NSString *videoUrl;
@property(nonatomic, copy)NSString *videoID;
@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *videoImage;
@property(nonatomic, copy)NSString *userName;
@property(nonatomic, copy)NSString *videoComment;
@property(nonatomic, copy)NSString *videoLocation;
@property(nonatomic, copy)NSString *videoTime;
+ (instancetype)annotationWithThumbnail:(JPSThumbnail *)thumbnail;
- (id)initWithThumbnail:(JPSThumbnail *)thumbnail;
- (void)updateThumbnail:(JPSThumbnail *)thumbnail animated:(BOOL)animated;

@end
