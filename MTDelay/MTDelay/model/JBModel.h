//
//  JBDelayModel.h
//  MTDelay
//
//  Created by Jabari Bell on 5/8/14.
//  Copyright (c) 2014 Jabari Bell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBLine.h"

@interface JBModel : NSObject

- (NSArray *)getLinesByStatus:(JBLineStatus)status;

+ (instancetype)sharedInstance;

@end
