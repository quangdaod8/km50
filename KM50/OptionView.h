//
//  OptionView.h
//  KM50
//
//  Created by Duy Quang on 1/22/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface OptionView : UITableViewController
@property (weak, nonatomic) IBOutlet UISwitch *swViettel;

@property (weak, nonatomic) IBOutlet UISwitch *swMobi;
@property (weak, nonatomic) IBOutlet UISwitch *swVina;
@property (strong, nonatomic) GADInterstitial *fullAd;

@end
