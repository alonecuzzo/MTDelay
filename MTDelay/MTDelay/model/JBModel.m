//
//  JBDelayModel.m
//  MTDelay
//
//  Created by Jabari Bell on 5/8/14.
//  Copyright (c) 2014 Jabari Bell. All rights reserved.
//

#import "JBModel.h"

#import <GDataXML-HTML/GDataXMLNode.h>

@interface JBModel ()

@property (nonatomic, copy) NSArray *lines;

@end

@implementation JBModel

#pragma mark - model methods

- (NSArray *)getLinesByStatus:(JBLineStatus)status
{
    NSMutableArray *outArray = [NSMutableArray array];
    for (JBLine *line in self.lines) {
        if (line.status == status) {
            [outArray addObject:line];
        }
    }
    return [outArray copy];
}

//more functions here
// get lines by name
// get lines by date
// get lines by text


#pragma mark - init stuff

+ (instancetype)sharedInstance
{
    static JBModel *sharedModel;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        sharedModel = [[JBModel alloc] init];
    });
    return sharedModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lines = [JBModel parsedLines];
    }
    return self;
}

+ (NSString *)dataFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"data" ofType:@"xml"];
}

+ (GDataXMLDocument *)loadData
{
    NSString *filePath = [self dataFilePath];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    return [[GDataXMLDocument alloc] initWithData:xmlData error:&error];
}

+ (NSArray *)parsedLines
{
    GDataXMLDocument *doc = [JBModel loadData];
    NSArray *subwayNode = [doc.rootElement elementsForName:@"subway"];
    NSArray *subwayLines = [subwayNode[0] elementsForName:@"line"];
    NSMutableArray *parsedLines = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    for (GDataXMLElement *element in subwayLines) {
        
        JBLine *line = [[JBLine alloc] init];
        
        NSArray *names = [element elementsForName:@"name"];
        if (names.count > 0) {
            GDataXMLElement *name = (GDataXMLElement *)names[0];
            line.lineName = name.stringValue;
        }
        
        NSArray *statuses = [element elementsForName:@"status"];
        if (statuses.count > 0) {
            GDataXMLElement *status = (GDataXMLElement *)statuses[0];
            line.status = [JBModel lineStatusFromString:status.stringValue];
        }
        
        NSArray *texts = [element elementsForName:@"text"];
        if (texts.count > 0) {
            GDataXMLElement *text = (GDataXMLElement *)texts[0];
            line.text = text.stringValue;
        }
        
        NSString *dateReportedString = @"";
        NSArray *dateReportedValues = [element elementsForName:@"Date"];
        if (dateReportedValues.count > 0) {
            GDataXMLElement *dateReportedElement = (GDataXMLElement *)dateReportedValues[0];
            dateReportedString = dateReportedElement.stringValue;
        }
        
        NSString *timeReported = @"";
        NSArray *timeReportedValues = [element elementsForName:@"Time"];
        if (timeReportedValues.count > 0) {
            GDataXMLElement *timeReportedElement = (GDataXMLElement *)timeReportedValues[0];
            timeReported = timeReportedElement.stringValue;
            if (timeReported.length > 2) {
                NSMutableString *mutableTimeReported = [NSMutableString stringWithString:timeReported];
                [mutableTimeReported insertString:@" " atIndex:mutableTimeReported.length - 2];
                timeReported = [mutableTimeReported copy];
            }
        }
        
        line.dateReported = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@", dateReportedString, timeReported]];
        
        [parsedLines addObject:line];
    }
    return parsedLines;
}

+ (JBLineStatus)lineStatusFromString:(NSString *)status
{
    if ([status isEqualToString:@"GOOD SERVICE"]) {
        return JBLineStatusGoodService;
    } else if ([status isEqualToString:@"PLANNED WORK"]) {
        return JBLineStatusPlannedWork;
    } else if ([status isEqualToString:@"DELAYS"]) {
        return JBLineStatusDelays;
    } else if ([status isEqualToString:@"SERVICE CHANGE"]) {
        return JBLineStatusServiceChange;
    } else {
        return JBLineStatusUnknown;
    }
}

@end
