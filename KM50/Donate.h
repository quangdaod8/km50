//
//  Donate.h
//  KM50
//
//  Created by Duy Quang on 2/8/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NetworkService.h"

@interface Donate : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtMain;
@property (strong,nonatomic) NetworkService *service;

@end
