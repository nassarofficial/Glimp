//
//  VideoModel.m
//  Glimp
//
//  Created by Ahmed Salah on 9/23/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
- (id)initWithData:(NSDictionary *)data{
    if (![data isKindOfClass:[NSNull class]]) {
        self.videoLocation  = [[[data objectForKey:@"Location"]stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        self.videoUrl       =  [data objectForKey:@"VideoURL"];
        self.longitude      =  [[data objectForKey:@"Longitude"] doubleValue];
        self.latitude       =  [[data objectForKey:@"Latitude" ] doubleValue];
        self.noOflikes      =  [[data valueForKey:@"NoLikes"] intValue];
        self.noOfViews      =  [[data valueForKey:@"NoViews"] intValue];
        self.noOfComments   =  [[data objectForKey:@"NoComments"] intValue];
        self.comment        =  [data objectForKey:@"Comment"] ;
        self.videoID        =  [[data objectForKey:@"ID"] stringValue];
        self.videoImage     =  [data objectForKey:@"VideoImageURL"];
        self.userName       =  [data objectForKey:@"UserName"];
        self.isLiked        =  [[data objectForKey:@"IsLiked"] boolValue];
        self.uploadedTime   =  [data objectForKey:@"UploadedSince"];
        self.videoUserImage =  [data objectForKey:@"UserImage"];
        self.isLive         =  [[data objectForKey:@"IsActive"] boolValue];
        self.userID         =  [[data objectForKey:@"UserId"] stringValue];
    }
    return self;
}

@end
