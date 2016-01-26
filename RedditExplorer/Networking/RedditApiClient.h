//
//  RedditApiClient.h
//  RedditExplorer
//
//  Created by Gregory Lee on 1/25/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Listing;
typedef void(^FetchBlock)(NSArray *fetchedObjects,NSString *afterName);
typedef void(^ErrorBlock)(NSError *error);

@interface RedditApiClient : NSObject
+ (instancetype)sharedInstance;
- (void)fetchListingsAfterListingName:(NSString *)afterListingName
                         currentCount:(NSInteger)currentCount
                              success:(FetchBlock)success
                                 fail:(ErrorBlock)fail;

- (void)fetchCommentsForListing:(Listing *)listing
               afterCommentName:(NSString *)afterCommentName
                   currentCount:(NSInteger)currentCount
                        success:(FetchBlock)success
                           fail:(ErrorBlock)fail;


@end
