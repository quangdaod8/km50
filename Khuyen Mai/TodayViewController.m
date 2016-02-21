//
//  TodayViewController.m
//  Khuyen Mai
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _labelText.text = @"Đang làm mới dữ liệu ...";
    [self widgetPerformUpdateWithCompletionHandler:^(NCUpdateResult result) {
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Parse setApplicationId:@"NUgdGclAIEmYcwu8HAisyHGbT5eIfguOz6ITSRXb" clientKey:@"WBYwmDqkwOC7FCixLKM083fcw3UM1nTXYOQCl4wt"];
 

        // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    PFQuery *query = [PFQuery queryWithClassName:@"data"];
    [query whereKey:@"network" equalTo:@"widget"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(!error) {
            if([object[@"isKm"] boolValue]) {
                _labelText.text = object[@"message"];
                completionHandler(NCUpdateResultNewData);
            }
            else {
                _labelText.text = object[@"notnow"];
                completionHandler(NCUpdateResultNoData);
            }
        } else {
            _labelText.text = @"Lỗi kết nối!";
            completionHandler(NCUpdateResultFailed);
        }
    }];

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (IBAction)labelTap:(id)sender {
    NSLog(@"ok");
}
@end
