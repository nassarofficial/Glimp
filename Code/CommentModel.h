//
//  CommentModel.h
//  Glimp
//
//  Created by Ahmed Salah on 11/27/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property(nonatomic, strong)NSString *comment;
@property(nonatomic, strong)NSString *commentTime;
@property(nonatomic, strong)UserModel *user;
- (id)initWithData:(NSDictionary *)data;

@end
