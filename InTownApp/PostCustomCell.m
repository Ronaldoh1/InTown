//
//  PostCustomCell.m
//  InTown
//
//  Created by Ronald Hernandez on 9/4/15.
//  Copyright (c) 2015 inTown. All rights reserved.
//

#import "PostCustomCell.h"

@implementation PostCustomCell

- (void)awakeFromNib {
    // Initialization code

    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 4.0;
    self.userImage.layer.borderColor = [UIColor colorWithRed:254.0/255.0 green:94/255.0 blue:1.0/255.0 alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
