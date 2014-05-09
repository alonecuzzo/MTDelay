//
//  JBLine.h
//  MTDelay
//
//  Created by Jabari Bell on 5/8/14.
//  Copyright (c) 2014 Jabari Bell. All rights reserved.
//

typedef NS_ENUM(NSInteger, JBLineStatus) {
    JBLineStatusUnknown = -1,
    JBLineStatusGoodService,
    JBLineStatusServiceChange,
    JBLineStatusPlannedWork,
    JBLineStatusDelays
};

#import <Foundation/Foundation.h>

@interface JBLine : NSObject

@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, assign) JBLineStatus status;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSDate *dateReported;

@end
