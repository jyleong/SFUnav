//
//  RoadReportTableCell.h
//  SFUnavapp
//
//  Created by James Leong on 2015-03-26.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoadReportTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *openstatusLabel;

@end
