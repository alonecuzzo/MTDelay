//
//  JBViewController.m
//  MTDelay
//
//  Created by Jabari Bell on 5/8/14.
//  Copyright (c) 2014 Jabari Bell. All rights reserved.
//

#import "JBViewController.h"
#import "JBModel.h"

@interface JBViewController ()

@end

@implementation JBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JBModel *model = [JBModel sharedInstance];
    NSLog(@"lines with planned work: %@", [model getLinesByStatus:JBLineStatusPlannedWork]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
