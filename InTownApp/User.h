//
//  User.h
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface User : PFUser<PFSubclassing>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *aboutMe;
@property (nonatomic, strong) PFFile *profileImage;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *orientation;
@property (nonatomic, strong) NSMutableArray *languageArray;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *userAdministrativeArea;
@property (nonatomic, strong) NSString *userCountryCode;
@property (nonatomic, strong) PFGeoPoint *currentLoccation;

//List of Users who sent Messages
@property (nonatomic, strong) NSMutableArray *inboxArray;

@property (assign) BOOL isFbUser;
//Activities Joined & Accepted

@end