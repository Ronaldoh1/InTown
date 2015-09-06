//
//  inbox.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/23/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "Inbox.h"

@implementation Inbox

@dynamic inboxOwner;
@dynamic messageContact;
@dynamic messageContactUsername;
@dynamic inboxOwnerUsername;


+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Inbox";
}

@end
