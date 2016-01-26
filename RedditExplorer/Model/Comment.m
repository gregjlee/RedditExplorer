//
//  Comment.m
//  RedditExplorer
//
//  Created by Gregory Lee on 1/25/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import "Comment.h"

@implementation Comment
- (instancetype)initWithCommentData:(NSDictionary *)commentData
{
    self = [super init];
    if ( self ) {
        _author = commentData[@"author"];
        _body = commentData[@"body"];
    }
    return self;
}

@end
