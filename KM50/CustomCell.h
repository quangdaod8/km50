//
//  CustomCell.h
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "networkData.h"

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgNetwork;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
-(void)setDataByNetworkData:(networkData*)networkData;
@end
