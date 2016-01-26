//
//  Listing.m
//  RedditExplorer
//
//  Created by Gregory Lee on 1/25/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import "Listing.h"

@implementation Listing
- (instancetype)initWithListingData:(NSDictionary *)listingData
{
    self = [super init];
    if ( self ) {
        _title = listingData[@"title"];
        _identifier = listingData[@"id"];
        _subReddit = listingData[@"subreddit"];
        _imageURL = listingData[@"url"];
    }
    return self;
}

@end
