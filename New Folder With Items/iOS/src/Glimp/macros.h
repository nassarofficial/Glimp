//
//  macros.h
//  Qiyas
//
//  Created by Ahmed Salah on 3/10/14.
//  Copyright (c) 2014 ITWorx. All rights reserved.
//

#ifndef Glimp_macros_h
#define Glimp_macros_h


// OS Information
#define IOS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define IOS_7_LESS [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending
#define IOS_6_OR_LATER [[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending
#define IOS_5_OR_LATER [[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending
#define IOS_4_OR_LATER [[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] != NSOrderedAscending
#define ONLY_IF_AT_LEAST_IOS_4(action) if ([[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] != NSOrderedAscending) { action; }

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE (![[[UIDevice currentDevice] model] hasPrefix:@"iPad"])
#define IS_IPAD ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"])

// User Interface Related
#define HexColor(c)                         [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define NSHexColor(c)                       [NSColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define RGB(r, g, b)                      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define SetNetworkActivityIndicator(x)      [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define NavBar                              self.navigationController.navigationBar
#define TabBar                              self.tabBarController.tabBar
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y


//
#define CachedPlistPath [[NSBundle mainBundle] pathForResource:@"cachedData" ofType:@"plist"]

// Rect stuff
#define CGWidth(rect)                   rect.size.width
#define CGHeight(rect)                  rect.size.height
#define CGOriginX(rect)                 rect.origin.x
#define CGOriginY(rect)                 rect.origin.y
#define CGRectCenter(rect)              CGPointMake(NSOriginX(rect) + NSWidth(rect) / 2, NSOriginY(rect) + NSHeight(rect) / 2)
#define CGRectModify(rect,dx,dy,dw,dh)  CGRectMake(rect.origin.x + dx, rect.origin.y + dy, rect.size.width + dw, rect.size.height + dh)
#define DLogRect(rect)                 DLog(@"%@", NSStringFromCGRect(rect))
#define DLogSize(size)                 DLog(@"%@", NSStringFromCGSize(size))
#define DLogPoint(point)               DLog(@"%@", NSStringFromCGPoint(point))
#endif
