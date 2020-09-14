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
@end

#pragma mark - View Lifecycle

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Zones"];
    [self getZones];
}

#pragma mark - Get Zones

- (void)getZones {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://med-api.admost.com/v4.1/zones/15066ddc-9c18-492c-8185-bea7e4c7f88c" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        self->_zoneList = dict[@"Zones"];
        [self.TBLZone reloadData];
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"getDeviceScanResults: failure: %@", error.localizedDescription);
    }];
}

#pragma mark - UITableView DataSource Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _zoneList[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _zoneList.count;  //array.count gelmeli
}

@end
