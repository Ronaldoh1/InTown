//
//  DialogVC.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/11/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface DialogVC : UIViewController

@property (strong, nonatomic) NSString *chatMateId;
@property User *selectedRecipient;

@end
