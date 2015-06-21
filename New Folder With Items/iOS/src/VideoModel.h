//
//  VideoModel.h
//  Glimp
//
//  Created by Ahmed Salah on 9/23/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
@property(nonatomic, strong)NSString *videoUrl;
@property(nonatomic, strong)NSString *userName;
@property(nonatomic, assign)int noOflikes;
@property(nonatomic, assign)int noOfViews;
@property(nonatomic, assign)BOOL isLiked;
@property(nonatomic, assign)BOOL isLive;

@property(nonatomic, assign)int noOfComments;
@property(nonatomic, assign)double longitude;
@property(nonatomic, assign)double latitude;
@property(nonatomic, strong)NSString *comment;
@property(nonatomic, strong)NSString *videoLocation;

@property(nonatomic, strong)NSString *videoID;
@property(nonatomic, strong)NSString *userID;
@property(nonatomic, strong)NSString *videoImage;
@property(nonatomic, strong)NSString *videoUserImage;
@property(nonatomic, strong)NSString *uploadedTime;
- (id)initWithData:(NSDictionary *)data;

@end
