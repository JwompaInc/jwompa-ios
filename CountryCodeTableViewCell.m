
//
//  CountryCodeTableViewCell.m
//  iMergency
//
//  Created by OBSMACMINI2 on 4/28/16.
//  Copyright © 2016 OBSMACMINI2. All rights reserved.
//


#import "CountryCodeTableViewCell.h"

@implementation CountryCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countryCode.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
