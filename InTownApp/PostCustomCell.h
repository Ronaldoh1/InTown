//
//  PostCustomCell.h
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UIButton *coolButton;
@property (weak, nonatomic) IBOutlet UIButton *posterUserName;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *postDate;

@end
