//
//  Detail.h
//  KM50
//
//  Created by Duy Quang on 2/3/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "networkData.h"
#import "MBProgressHUD.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <MessageUI/MessageUI.h>

@interface Detail : UIViewController <GADInterstitialDelegate>
@property(strong,nonatomic) networkData* detail;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property(strong, nonatomic) GADInterstitial *full;
@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@end
