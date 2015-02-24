//
//  UserModel.h
//  Glimp
//
//  Created by Ahmed Salah on 9/22/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic, strong)NSString *userName;
@property(nonatomic, strong)NSString *firstName;
@property(nonatomic, strong)NSString *lastName;
@property(nonatomic, strong)NSString *birthDate;
@property(nonatomic, strong)NSNumber *gender;
@property(nonatomic, strong)NSString *imageUrl;
@property(nonatomic, strong)NSNumber *userId;
@property(nonatomic, strong)NSString *countryName;
@property(nonatomic, strong)NSString *countryCode;
@property(nonatomic, strong)NSString *deviceToken;
@property(nonatomic, strong)NSString *email;
@property(nonatomic, strong)NSString *mobileNo;
@property(nonatomic, strong)NSString *noOfFollowers;
@property(nonatomic, strong)NSString *noOfFollowing;
@property(nonatomic, strong)NSString *noOfVideos;
@property(nonatomic, assign)BOOL isFollowed;

- (id)initWithData:(NSDictionary *)data;
@end
