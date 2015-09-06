//
//  Message.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/11/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Activity.h"

@interface Message : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) User *recipient;
@property (nonatomic, strong) NSString *recipientUsername;
@property (nonatomic, strong) NSString *senderUsername;
@property (nonatomic, strong) User *sender;
@property (nonatomic, strong) NSString *messageText;

+(NSString *)parseClassName;



@end
