//
//  Annotation.m
//  CoreLocation2
//
//  Created by Ahmed Salah on 5/16/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate
{
    self = [super init];
    if (self) {
        _coordinate = aCoordinate;
    }
    return self;
}

//- (BOOL)isEqual:(Annotation *)annotation{
//    if (![annotation isKindOfClass:[Annotation class]])
//        return NO;
//    
//    return (self.coordinate.latitude == annotation.coordinate.latitude &&
//            self.coordinate.longitude == annotation.coordinate.longitude &&
//            [self.videoID  isEqualToString:annotation.videoID] &&
//            [self.Image isEqualToString:annotation.Image] &&
//            [self.videoUrl isEqualToString:annotation.videoUrl]&&
//            [self.videoComment isEqualToString:annotation.videoComment]&&
//            [self.userName isEqualToString:annotation.userName]&&
//            self.noOflikes == annotation.noOflikes);
//}
@end

