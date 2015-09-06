//
//  InboxCustomCell.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/13/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *blueDot;

@end
