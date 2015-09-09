//
//  Alerts.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/24/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
@interface Alert : PFObject<PFSubclassing>

@property (nonatomic, strong) User *recipient;
@property (nonatomic, strong) NSString *recipientUsername;
@property (nonatomic, strong) NSString *senderUsername;
@property (nonatomic, strong) User *sender;
@property (nonatomic, strong) NSNumber *messageIsNew; //0 = no, 1 = yes;

@end
