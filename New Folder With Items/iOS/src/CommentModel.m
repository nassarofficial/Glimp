//
//  CommentModel.m
//  Glimp
//
//  Created by Ahmed Salah on 11/27/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
- (id)initWithData:(NSDictionary *)data{
      if (data) {
          self.comment      =  [data objectForKey:@"CommentText"];
          self.commentTime      =  [data objectForKey:@"CommentTime"];

          self.user = [[UserModel alloc] initWithData:[data objectForKey:@"User"]];
      }
    return self;
}
@end
