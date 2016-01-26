//
//  ListingCommentsViewController.m
//  RedditExplorer
//
//  Created by Gregory Lee on 1/25/16.
//  Copyright © 2016 Gregory Lee. All rights reserved.
//

#import "ListingCommentsViewController.h"
#import "Listing.h"
#import "Comment.h"
#import "RedditApiClient.h"
#import <PureLayout.h>
#import <SVPullToRefresh.h>
#import <EXTScope.h>

@interface ListingCommentsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)Listing *listing;
@property (nonatomic,strong)NSMutableArray *comments;
@property (nonatomic,strong)NSString *afterName; //for indicating next page to load
@end

@implementation ListingCommentsViewController
#pragma mark - init
- (instancetype)initWithListing:(Listing *)listiing {
    self = [super init];
    if ( self ) {
        _listing = listiing;
    }
    return self;
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Comments";
    self.comments = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];

    @weakify(self);
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [[RedditApiClient sharedInstance] fetchCommentsForListing:self.listing
             afterCommentName:self.afterName
                 currentCount:self.comments.count
                      success:^(NSArray *fetchedObjects, NSString *afterName) {
                          self.afterName = afterName;
                          [self.comments addObjectsFromArray:fetchedObjects];
                          [self.tableView.infiniteScrollingView stopAnimating];
                          [self.tableView reloadData];
                      } fail:^(NSError *error) {
                          [self.tableView.infiniteScrollingView stopAnimating];
                      }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.comments.count == 0) {
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
    _tableView.dataSource = self;
    _tableView.delegate = self;
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CommentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.numberOfLines = 4;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Comment *comment = self.comments[indexPath.row];
    cell.textLabel.text = comment.author;
    cell.detailTextLabel.text = comment.body;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
