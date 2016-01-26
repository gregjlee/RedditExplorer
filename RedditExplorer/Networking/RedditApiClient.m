//
//  RedditApiClient.m
//  RedditExplorer
//
//  Created by Gregory Lee on 1/25/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import "RedditApiClient.h"
#import "AFNetworking.h"
#import "Listing.h"
#import "Comment.h"

static NSString *base_url = @"https://www.reddit.com/";
static const NSInteger kItemsToFetch = 20;

@interface RedditApiClient()
@property(nonatomic,strong)AFHTTPSessionManager *sessionManager;
@end

@implementation RedditApiClient

+ (instancetype)sharedInstance {
    static RedditApiClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[RedditApiClient alloc] init];
    });
    return client;
}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:base_url]];
    }
    return self;
}

- (void)fetchListingsAfterListingName:(NSString *)afterListingName
                         currentCount:(NSInteger)currentCount
                              success:(FetchBlock)success
                                 fail:(ErrorBlock)fail {
    NSString *after = ( afterListingName ) ? afterListingName : @"";
    NSDictionary *params = @{@"limit": @(kItemsToFetch),
                             @"count": @(currentCount),
                             @"after": after};
    [self.sessionManager GET:@"r/all/hot.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //parse objects
        NSDictionary *data = responseObject[@"data"];
        NSString *afterName = data[@"after"];
        NSArray *children = data[@"children"];
        NSMutableArray *listings = [NSMutableArray array];
        for ( NSDictionary *listingObject in children) {
            NSDictionary *listingData = listingObject[@"data"];
            Listing *listing = [[Listing alloc] initWithListingData:listingData];
            [listings addObject:listing];
        }
        if ( success ) {
            success(listings,afterName);
        }
        NSLog(@"listings %@",listings);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
        if ( fail ) {
            fail(error);
        }
    }];
}

- (void)fetchCommentsForListing:(Listing *)listing
               afterCommentName:(NSString *)afterCommentName
                   currentCount:(NSInteger)currentCount
                        success:(FetchBlock)success
                           fail:(ErrorBlock)fail {
    NSString *after = ( afterCommentName ) ? afterCommentName : @"";
    NSDictionary *params = @{@"limit": @(kItemsToFetch),
                             @"article": listing.identifier,
                             @"count": @(currentCount),
                             @"after": after,
                             @"sort": @"confidence"};
    NSString *commentsURL = [NSString stringWithFormat:@"r/%@/comments.json",listing.subReddit];
    [self.sessionManager GET:commentsURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //parse objects
        NSDictionary *data = responseObject[@"data"];
        NSString *afterName = data[@"after"];
        NSArray *children = data[@"children"];
        NSLog(@"after %@ comments %@",afterName, children);
        
        NSMutableArray *comments = [NSMutableArray array];
        for ( NSDictionary *commentsObject in children) {
            NSDictionary *commentData = commentsObject[@"data"];
            Comment *comment = [[Comment alloc] initWithCommentData:commentData];
            [comments addObject:comment];
        }
        if ( success ) {
            success(comments,afterName);
        }
        NSLog(@"comments %@",comments);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
        if ( fail ) {
            fail(error);
        }
    }];
}
@end
