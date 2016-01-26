//
//  Listing.h
//  RedditExplorer
//
//  Created by Gregory Lee on 1/25/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Listing : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *identifier;
@property(nonatomic,strong)NSString *subReddit;
@property(nonatomic,strong)NSString *imageURL;
- (instancetype)initWithListingData:(NSDictionary *)listingData;

@end
