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

@implementation AMRZoneDataSource

#pragma mark - Data

- (NSMutableArray *)loadZonesForAppId:(NSString *)appId
                           completion:(void (^)(NSMutableArray * _Nonnull))completion {
    
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

@end
