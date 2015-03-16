 //
//  ContactsTableViewCell.h
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-12.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *contactDetails;
@property (strong, nonatomic) IBOutlet UILabel *contactType;
@property (strong, nonatomic) IBOutlet UILabel *contactInfo;


@end
