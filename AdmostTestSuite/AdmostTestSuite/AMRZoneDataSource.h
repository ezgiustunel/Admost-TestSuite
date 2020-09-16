//
//  AMRZoneDataSource.h
//  AdmostTestSuite
//
//  Created by Mehmet Karagöz on 16.09.2020.
//  Copyright © 2020 Ezgi Ustunel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AMRZoneDataSource : NSObject
@property(nonatomic, strong) NSMutableArray *zoneList;
@property(nonatomic, strong) UILabel *noDataLabel;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

- (void)noDataLabelOperations:(NSString *)text tableView:(UITableView *)tableView;
- (void)refreshControlOperations;
- (void)setNoDataLabelHidden:(BOOL)hidden;
- (void)endRefreshControl;

- (NSMutableArray *)loadZones:(NSString *)appId
                   completion:(nullable void (^)(NSMutableArray * _Nonnull))completion;

@end
