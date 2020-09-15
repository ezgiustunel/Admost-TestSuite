//
//  ViewController.m
//  AdmostTestSuite
//
//  Created by Ezgi Ustunel on 14.09.2020.
//  Copyright © 2020 Ezgi Ustunel. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TBLZone;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

#pragma mark - View Lifecycle

@implementation ViewController {
    UILabel *_noDataLabel;
    UIRefreshControl *_refreshControl;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _TBLZone.bounds.size.width, _TBLZone.bounds.size.height)];
    [self setNoDataLabelHidden:YES];
    
    self->_noDataLabel.text = @"No data available";
    self->_noDataLabel.textColor = [UIColor blackColor];
    self->_noDataLabel.textAlignment = NSTextAlignmentCenter;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    _refreshControl.tintColor = [UIColor colorWithRed:0.25 green:0.72 blue:0.85 alpha:1.0];
    _refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Fetching"];
    
    _activityView.hidden = NO;
    [_activityView startAnimating];
    
    [self.navigationItem setTitle:@"Zones"];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self getZones];
      });
}

#pragma mark - Zone Operations

- (void)loadZones:(NSString *) appId {
    NSString *zoneURL = [NSString stringWithFormat:@"http://med-api.admost.com/v4.1/zones/%@", appId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:zoneURL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        self->_zoneList = dict[@"Zones"];
        
        [self.TBLZone reloadData];
        
        self->_activityView.hidden = YES;
        [self->_activityView stopAnimating];
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"getDeviceScanResults: failure: %@", error.localizedDescription);
    }];
}

- (void)getZones {
    [self loadZones:@"15066ddc-9c18-492c-8185-bea7e4c7f88c"];
}

- (void)refreshZones {
    [self loadZones:@"1b210a41-6566-4fb9-9e6c-0c1a132bb858"];
}

#pragma mark - UITableView DataSource Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView addSubview:_refreshControl];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _zoneList[indexPath.row];
    return cell;
}

- (void)refreshTableView {
    [self refreshZones];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _zoneList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self endRefreshControl:self->_refreshControl];
    });
    
    if (_zoneList.count > 0) {
        numOfSections = 1;
    }
    else {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self setNoDataLabelHidden:NO];
        });
    }
    return numOfSections;
}

- (void)setNoDataLabelHidden:(BOOL)hidden {
    _noDataLabel.hidden = hidden;
}

- (void)endRefreshControl:(UIRefreshControl *)refreshControl {
    if(refreshControl.refreshing) {
        [refreshControl endRefreshing];
    }
}

@end
