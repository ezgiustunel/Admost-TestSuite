//
//  AMRZoneDataSource.m
//  AdmostTestSuite
//
//  Created by Mehmet Karagöz on 16.09.2020.
//  Copyright © 2020 Ezgi Ustunel. All rights reserved.
//

#import "AMRZoneDataSource.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>

@implementation AMRZoneDataSource {
    
}

- (void)noDataLabelOperations:(NSString *)text tableView:(UITableView *)tableView {
    _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    _noDataLabel.text = text;
    _noDataLabel.textColor = [UIColor blackColor];
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)refreshControlOperations {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor colorWithRed:0.25 green:0.72 blue:0.85 alpha:1.0];
    _refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Fetching"];
}

- (NSMutableArray *)loadZones:(NSString *)appId
                   completion:(nullable void (^)(NSMutableArray * _Nonnull))completion {
    NSString *zoneURL = [NSString stringWithFormat:@"http://med-api.admost.com/v4.1/zones/%@", appId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:zoneURL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        self->_zoneList = dict[@"Zones"];
        
        completion(self->_zoneList);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"getDeviceScanResults: failure: %@", error.localizedDescription);
    }];
    
    return _zoneList;
}

- (void)setNoDataLabelHidden:(BOOL)hidden {
    _noDataLabel.hidden = hidden;
}

- (void)endRefreshControl {
    if(_refreshControl.refreshing) {
        [_refreshControl endRefreshing];
    }
}

@end
