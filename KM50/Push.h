//
//  Push.h
//  KM50
//
//  Created by Duy Quang on 2/8/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService.h"
#import "MBProgressHUD.h"

@interface Push : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UISwitch *swVina;
@property (weak, nonatomic) IBOutlet UISwitch *swMobi;

@property (weak, nonatomic) IBOutlet UISwitch *swViettel;
@property (weak, nonatomic) IBOutlet UISwitch *swBadge;
@property (strong, nonatomic) NetworkService *service;
@end
