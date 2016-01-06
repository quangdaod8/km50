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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataByNetworkData:(networkData *)networkData {
    _imgNetwork.image = [UIImage imageNamed:networkData.network];
    if(networkData.isKm) _labelMessage.text = networkData.message;
    else _labelMessage.text = networkData.notnow;
}

@end
