//
//  NetworkDetail.h
//  KM50
//
//  Created by Duy Quang on 2/8/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService.h"
#import "networkData.h"
#import "MBProgressHUD.h"
@interface NetworkDetail : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtNetwork;
@property (weak, nonatomic) IBOutlet UITextView *txtNetworkDetail;
@property (weak, nonatomic) IBOutlet UISwitch *swisKm;
@property (strong, nonatomic) NetworkService *service;
@property (strong, nonatomic) NSString *network;


- (IBAction)swisKmPress:(id)sender;

@end
