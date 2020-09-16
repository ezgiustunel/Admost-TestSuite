//
//  ViewController.m
//  AdmostTestSuite
//
//  Created by Ezgi Ustunel on 14.09.2020.
//  Copyright © 2020 Ezgi Ustunel. All rights reserved.
//

#import "ViewController.h"
#import "AMRZoneDataSource.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TBLZone;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

#pragma mark - View Lifecycle

@implementation ViewController {
    AMRZoneDataSource *_zoneDataSource;
    UILabel *_lblNoData;
    UIRefreshControl *_refreshControl;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    _zoneDataSource = [AMRZoneDataSource new];
    [self loadDataForAppId:@"15066ddc-9c18-492c-8185-bea7e4c7f88c"];
}

- (void)setupViews {
    [self.navigationItem setTitle:@"Zones"];
    
    _lblNoData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _TBLZone.bounds.size.width, _TBLZone.bounds.size.height)];
    _lblNoData.text = @"No data available";
    _lblNoData.textColor = [UIColor blackColor];
    _lblNoData.textAlignment = NSTextAlignmentCenter;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor colorWithRed:0.25 green:0.72 blue:0.85 alpha:1.0];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetching"];
    
    [_refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    _activityView.hidden = NO;
}

- (void)loadDataForAppId:(NSString *)appId {
    [_activityView startAnimating];
    [_zoneDataSource loadZonesForAppId:@"15066ddc-9c18-492c-8185-bea7e4c7f88c" completion:^(NSMutableArray *zoneList) {
        [self->_TBLZone reloadData];
        self->_activityView.hidden = YES;
        [self->_activityView stopAnimating];
    }];
}

- (void)refreshTableView {
    [self loadDataForAppId:@"1b210a41-6566-4fb9-9e6c-0c1a132bb858"];
}

#pragma mark - UITableView DataSource Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    [tableView addSubview:_zoneDataSource.refreshControl];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _zoneDataSource.zoneList[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _zoneDataSource.zoneList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
//        [self->_refreshControl endRefreshControl];
    });
    
    if (_zoneDataSource.zoneList.count > 0) {
        numOfSections = 1;
    }
    else {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
//            [self->_refreshControl setNoDataLabelHidden:NO];
        });
    }
    return numOfSections;
}

@end
