//
//  Info.h
//  KM50
//
//  Created by Duy Quang on 1/6/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>

@interface Info : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property(assign,nonatomic) int i;
- (IBAction)btnSetup:(id)sender;

@end
