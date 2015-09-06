//
//  Post.m
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic likesCounts;
@dynamic postText;
@dynamic postOwner;
@dynamic locationGeoPoint;
@dynamic postOnwerUsername;
@dynamic LikerArray;

+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Post";
}
@end
