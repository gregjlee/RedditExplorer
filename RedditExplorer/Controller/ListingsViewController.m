//
//  ListingsViewController.m
//  RedditExplorer
//
//  Created by Gregory Lee on 1/25/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import "ListingsViewController.h"
#import "RedditApiClient.h"
#import "Listing.h"
#import <PureLayout.h>
#import <SVPullToRefresh.h>
#import "ListingCommentsViewController.h"
#import <EXTScope.h>
#import <UIImageView+AFNetworking.h>

@interface ListingsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *listings;
@property (nonatomic,strong)NSString *afterListingName; //for indicating next page to load
@end

@implementation ListingsViewController
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Hot";
    self.listings = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    @weakify(self);
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [[RedditApiClient sharedInstance] fetchListingsAfterListingName:self.afterListingName
           currentCount:self.listings.count
                success:^(NSArray *fetchedListings, NSString *afterListingName) {
                    self.afterListingName = afterListingName;
                    [self.listings addObjectsFromArray:fetchedListings];
                    [self.tableView.infiniteScrollingView stopAnimating];
                    [self.tableView reloadData];
                } fail:^(NSError *error) {
                    [self.tableView.infiniteScrollingView stopAnimating];
                }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.listings.count == 0) {
        //initial fetch
        [self.tableView triggerInfiniteScrolling];
    }
}

#pragma mark - lazy property
- (UITableView *)tableView {
    if ( _tableView ) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 3;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Listing *listing = self.listings[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:listing.imageURL] placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];
    cell.textLabel.text = listing.title;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Listing *listing = self.listings[indexPath.row];
    ListingCommentsViewController *listingCommentsViewController = [[ListingCommentsViewController alloc] initWithListing:listing];
    [self.navigationController pushViewController:listingCommentsViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
