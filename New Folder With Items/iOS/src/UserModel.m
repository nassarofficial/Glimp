//
//  UserModel.m
//  Glimp
//
//  Created by Ahmed Salah on 9/22/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
- (id)initWithData:(NSDictionary *)data{
    
    if (![data isKindOfClass:[NSNull class]]) {
        self.userName                   = [data objectForKey:@"UserName"];
        self.firstName                  = [data objectForKey:@"FirstName"];
        self.lastName                   = [data objectForKey:@"LastName"];
        self.gender                     = [data objectForKey:@"Gender"];
        self.birthDate                  = [data objectForKey:@"BirthDate"];
        self.imageUrl                   = [data objectForKey:@"ImageUrl"];
        self.userId                     = [data objectForKey:@"UserId"];
        self.countryCode                = [data objectForKey:@"CountryCode"];
        self.countryName                = [data objectForKey:@"CountryName"];
        self.deviceToken                = [data objectForKey:@"DeviceToken"];
        self.email                      = [data objectForKey:@"Email"];
        self.mobileNo                   = [data objectForKey:@"Mobile"];
        self.noOfFollowers              = [[data objectForKey:@"NOofFollowers"] stringValue];
        self.noOfFollowing              = [[data objectForKey:@"NOofFollowings"] stringValue];
        self.noOfVideos                 = [[data objectForKey:@"NoOfVideos"] stringValue];

        self.isFollowed                 = [[data objectForKey:@"IsFollowedByCurrentUser"]boolValue];
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userName                    forKey:@"UserName"];
    [aCoder encodeObject:self.firstName    	              forKey:@"FirstName"];
    [aCoder encodeObject:self.lastName    	              forKey:@"LastName"];
    [aCoder encodeObject:self.gender    	              forKey:@"Gender"];
    [aCoder encodeObject:self.imageUrl    	              forKey:@"ImageUrl"];
    [aCoder encodeObject:self.birthDate    	              forKey:@"BirthDate"];
    [aCoder encodeObject:self.userId                      forKey:@"UserId"];
    [aCoder encodeObject:self.countryCode    	          forKey:@"CountryCode"];
    [aCoder encodeObject:self.countryName                 forKey:@"CountryName"];
    [aCoder encodeObject:self.deviceToken                 forKey:@"DeviceToken"];
    [aCoder encodeObject:self.email                       forKey:@"Email"];
    [aCoder encodeObject:self.mobileNo                    forKey:@"Mobile"];
    [aCoder encodeObject:self.noOfFollowing               forKey:@"noOfFollowing"];
    [aCoder encodeObject:self.noOfFollowers               forKey:@"noOfFollowers"];
    [aCoder encodeObject:self.noOfVideos                  forKey:@"NoOfVideos"];
    [aCoder encodeBool:self.isFollowed                    forKey:@"isFollowed"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.userName                                   =	[aDecoder decodeObjectForKey:@"UserName"];
        self.firstName                                  =	[aDecoder decodeObjectForKey:@"FirstName"];
        self.lastName                                   =	[aDecoder decodeObjectForKey:@"LastName"];
        self.gender                                     =	[aDecoder decodeObjectForKey:@"Gender"];
        self.imageUrl                                   =	[aDecoder decodeObjectForKey:@"ImageUrl"];
        self.birthDate                                  =	[aDecoder decodeObjectForKey:@"BirthDate"];
        self.userId                                     =	[aDecoder decodeObjectForKey:@"UserId"];
        self.countryCode                                =	[aDecoder decodeObjectForKey:@"CountryCode"];
        self.countryName                                =	[aDecoder decodeObjectForKey:@"CountryName"];
        self.deviceToken                                =	[aDecoder decodeObjectForKey:@"DeviceToken"];
        self.email                                      =	[aDecoder decodeObjectForKey:@"Email"];
        self.mobileNo                                   =	[aDecoder decodeObjectForKey:@"Mobile"];
        self.noOfFollowers                              =	[aDecoder decodeObjectForKey:@"noOfFollowers"];
        self.noOfFollowing                              =	[aDecoder decodeObjectForKey:@"noOfFollowing"];
        self.noOfVideos                                 =	[aDecoder decodeObjectForKey:@"NoOfVideos"];
        self.isFollowed                                 =	[aDecoder decodeBoolForKey:@"isFollowed"];

    }
    return self;
}
@end
