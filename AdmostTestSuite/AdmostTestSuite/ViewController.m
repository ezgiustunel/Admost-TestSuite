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
    UILabel *noDataLabel;
    UIRefreshControl *refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _TBLZone.bounds.size.width, _TBLZone.bounds.size.height)];
    refreshControl = [[UIRefreshControl alloc] init];
    noDataLabel.hidden = YES;
    noDataLabel.text = @"";
    _activityView.hidden = NO;
    [_activityView startAnimating];
    [self.navigationItem setTitle:@"Zones"];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Do some work");
        [self getZones];
      });
}

#pragma mark - Zone Operations

- (void)getZones {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://med-api.admost.com/v4.1/zones/15066ddc-9c18-492c-8185-bea7e4c7f88c" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        self->_zoneList = dict[@"Zones"];
        [self.TBLZone reloadData];
        self->_activityView.hidden = YES;
        [self->_activityView stopAnimating];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"getDeviceScanResults: failure: %@", error.localizedDescription);
    }];
}

- (void)refreshZones {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://med-api.admost.com/v4.1/zones/1b210a41-6566-4fb9-9e6c-0c1a132bb858" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        self->_zoneList = dict[@"Zones"];
        [self.TBLZone reloadData];
        self->_activityView.hidden = YES;
        [self->_activityView stopAnimating];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"getDeviceScanResults: failure: %@", error.localizedDescription);
    }];
}

#pragma mark - UITableView DataSource Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:0.25 green:0.72 blue:0.85 alpha:1.0];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Fetching"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _zoneList[indexPath.row];
    tableView.dragInteractionEnabled = YES;

    return cell;
}

- (void)refreshTableView {
    [self refreshZones];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _zoneList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if (_zoneList.count > 0)
    {
        //_TBLZone.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections = 1;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if(self->refreshControl.refreshing) {
                [self->refreshControl endRefreshing];
            }
            /*self->refreshControl = nil;
            [self->refreshControl endRefreshing];
            [self->refreshControl removeFromSuperview];*/
        });
 
        //_TBLZone.backgroundView = nil;
    }
    else
    {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self->noDataLabel.hidden = NO;
            self->noDataLabel.text = @"No data available";
            self->noDataLabel.textColor = [UIColor blackColor];
            self->noDataLabel.textAlignment = NSTextAlignmentCenter;
            //self->_TBLZone.backgroundView = self->noDataLabel;
            //self->_TBLZone.separatorStyle = UITableViewCellSeparatorStyleNone;
        });
    }
    return numOfSections;
}

@end
