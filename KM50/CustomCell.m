//
//  CustomCell.m
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataByNetworkData:(networkData *)networkData {
    _imgNetwork.image = [UIImage imageNamed:networkData.network];
    if(networkData.isKm) {
        _labelMessage.text = networkData.message;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.userInteractionEnabled = YES;
    }
    else {
        _labelMessage.text = networkData.notnow;
        _labelMessage.textColor = [UIColor grayColor];
    }
}

@end
