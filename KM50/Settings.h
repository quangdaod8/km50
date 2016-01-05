//
//  Settings.h
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService.h"
#import "networkData.h"
#import "MBProgressHUD.h"
@interface Settings : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtViettel;
@property (weak, nonatomic) IBOutlet UITextField *txtMobi;
@property (weak, nonatomic) IBOutlet UITextField *txtVina;
@property (weak, nonatomic) IBOutlet UITextField *txtWidget;
@property (weak, nonatomic) IBOutlet UITextField *txtPush;
@property (weak, nonatomic) IBOutlet UISwitch *swViettel;
@property (weak, nonatomic) IBOutlet UISwitch *swmobi;
@property (weak, nonatomic) IBOutlet UISwitch *swVina;
@property (weak, nonatomic) IBOutlet UISwitch *swWidget;
- (IBAction)btnTest:(id)sender;

- (IBAction)btnSend:(id)sender;
@end
