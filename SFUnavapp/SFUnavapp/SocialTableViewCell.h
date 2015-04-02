//
//  SocialTableViewCell.h
//  SFUnavapp
//  Team NoMacs
//
//  Created by James Leong on 2015-03-30.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *fbButton;
@property (nonatomic, weak) IBOutlet UIButton *twButton;
@property (nonatomic, weak) IBOutlet UIButton *ytButton;

@end
