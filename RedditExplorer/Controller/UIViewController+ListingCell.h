//
//  UIViewController+ListingCell.h
//  RedditExplorer
//
//  Created by Gregory Lee on 1/26/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Listing;
extern NSInteger const ListingCellHeight;
@interface UIViewController (ListingCell)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath listing:(Listing *)listing;

@end
