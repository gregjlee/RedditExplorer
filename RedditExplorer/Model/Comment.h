//
//  Comment.h
//  RedditExplorer
//
//  Created by Gregory Lee on 1/25/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *body;
- (instancetype)initWithCommentData:(NSDictionary *)commentData;
@end
