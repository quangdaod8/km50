//
//  ViewController.h
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "NetworkService.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Detail.h"
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;
@property(nonatomic, readonly) UIUserNotificationType types;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UIView *header;


@end

