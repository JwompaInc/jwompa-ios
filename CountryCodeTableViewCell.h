//
//  CountryCodeTableViewCell.h
//  iMergency
//
//  Created by OBSMACMINI2 on 4/28/16.
//  Copyright © 2016 OBSMACMINI2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryCodeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *countryName;
@property (strong, nonatomic) IBOutlet UILabel *countryCode;
@property (strong, nonatomic) IBOutlet UILabel *countryEmoji;

@end
