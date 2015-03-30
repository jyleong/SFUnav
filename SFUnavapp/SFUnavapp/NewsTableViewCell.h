//
//  NewsTableViewCell.h
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-29.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;


@property (weak, nonatomic) IBOutlet UILabel *author;


@property (weak, nonatomic) IBOutlet UILabel *pubDate;


@end
