//
//  Alerts.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/24/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "Alert.h"

@implementation Alert
@dynamic recipient;
@dynamic sender;
@dynamic recipientUsername;
@dynamic senderUsername;
@dynamic messageIsNew;

+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Alert";
}
@end
