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
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    _zoneDataSource = [AMRZoneDataSource new];
    
    [_zoneDataSource noDataLabelOperations:@"No data available" tableView:_TBLZone];
    [_zoneDataSource setNoDataLabelHidden:YES];
    
    [_zoneDataSource refreshControlOperations];
    _activityView.hidden = NO;
    [_activityView startAnimating];
    
    [self.navigationItem setTitle:@"Zones"];
    
    [_zoneDataSource.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];

    [_activityView startAnimating];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
          [self->_zoneDataSource loadZones:@"15066ddc-9c18-492c-8185-bea7e4c7f88c" completion:^(NSMutableArray * zoneList) {
              [self->_TBLZone reloadData];
              self->_activityView.hidden = YES;
              [self->_activityView stopAnimating];
          }];
      });
}

- (void)refreshTableView {
    [_zoneDataSource loadZones:@"1b210a41-6566-4fb9-9e6c-0c1a132bb858" completion:^(NSMutableArray * zoneList) {
        [self->_TBLZone reloadData];
    }];
}

#pragma mark - UITableView DataSource Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView addSubview:_zoneDataSource.refreshControl];
    //[tableView addSubview:_refreshControl];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _zoneDataSource.zoneList[indexPath.row];
    //cell.textLabel.text = _zoneList[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _zoneDataSource.zoneList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self->_zoneDataSource endRefreshControl];
    });
    
    if (_zoneDataSource.zoneList.count > 0) {
        numOfSections = 1;
    }
    else {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self->_zoneDataSource setNoDataLabelHidden:NO];
        });
    }
    return numOfSections;
}

@end
