//
//  LibraryHoursTableViewCell.h
//  SFUnavapp
//
//  Created by Serena Chan on 2015-04-07.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryHoursTableViewCell : UITableViewCell
@property (strong,nonatomic) UILabel *libraryName;
@property (strong,nonatomic) UILabel *libraryStatus;
@property (strong,nonatomic) UILabel *openTime;
@property (strong,nonatomic) UILabel *closeTime;
@end
