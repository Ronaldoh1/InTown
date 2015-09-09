//
//  Message.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/11/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "Message.h"

@implementation Message
@dynamic subject;
@dynamic sender;
@dynamic messageText;
@dynamic recipientUsername;
@dynamic senderUsername;
@dynamic isNew;


+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Message";
}


@end
