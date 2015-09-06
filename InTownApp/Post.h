//
//  Post.h
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "User.h"

@interface Post : PFObject<PFSubclassing>

@property User *postOwner;
@property NSString *postOnwerUsername;
@property NSString *postText;
@property NSString *likesCounts;
@property PFGeoPoint *locationGeoPoint;
@property NSMutableArray *LikerArray;

@end
