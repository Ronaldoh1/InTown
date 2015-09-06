//
//  User.m
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic name;
@dynamic aboutMe;
@dynamic profileImage;
@dynamic gender;
@dynamic orientation;
@dynamic languageArray;
@dynamic age;
@dynamic userAdministrativeArea;
@dynamic userCountryCode;
@dynamic currentLoccation;
@dynamic inboxArray;
@dynamic isFbUser;

+(void)load {
    [self registerSubclass];
}

@end