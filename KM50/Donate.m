//
//  Donate.m
//  KM50
//
//  Created by Duy Quang on 2/8/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "Donate.h"

@interface Donate ()

@end

@implementation Donate

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _service = [[NetworkService alloc]init];
    [_service getInfoByNetwork:@"widget" Completed:^(networkData *networkData, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!error) {
            _txtMain.text = networkData.detail;
        } else _txtMain.text = @"Không thể tải thông tin\nVui lòng thử lại trong chốc lát";
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
