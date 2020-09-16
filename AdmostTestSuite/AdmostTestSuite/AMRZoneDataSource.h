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
@property(nonatomic, strong) NSMutableArray * _Nullable zoneList;

- (NSMutableArray *)loadZonesForAppId:(NSString *)appId
                           completion:(void (^)(NSMutableArray * _Nonnull))completion;

@end
