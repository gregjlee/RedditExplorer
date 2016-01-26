//
//  UIViewController+ListingCell.m
//  RedditExplorer
//
//  Created by Gregory Lee on 1/26/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import "UIViewController+ListingCell.h"
#import "Listing.h"
#import <UIImageView+AFNetworking.h>
NSInteger const ListingCellHeight = 80;

@implementation UIViewController (ListingCell)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath listing:(Listing *)listing
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 3;
    }
    [cell.imageView setImageWithURL:[NSURL URLWithString:listing.imageURL] placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];
    cell.textLabel.text = listing.title;
    return cell;
}
@end
