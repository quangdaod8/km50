//
//  Settings.m
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkService *service = [[NetworkService alloc]init];
    [service getDataForArray:^(NSArray *data, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            networkData *vina = [[networkData alloc]init];
            vina = data[0];
            _txtVina.text = vina.message;
            [_swVina setOn:vina.isKm animated:YES];
            
            networkData *mobi = [[networkData alloc]init];
            mobi = data[1];
            _txtMobi.text = mobi.message;
            [_swmobi setOn:mobi.isKm animated:YES];
            
            networkData *vt = [[networkData alloc]init];
            vt = data[2];
            _txtViettel.text = vt.message;
            [_swViettel setOn:vt.isKm animated:YES];
            
            networkData *wg = [[networkData alloc]init];
            wg = data[3];
            _txtWidget.text = wg.message;
            [_swWidget setOn:wg.isKm animated:YES];
            
        } else [self dismissViewControllerAnimated:YES completion:nil];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Nhà Phát Triển";
    self.navigationItem.backBarButtonItem.title = @" ";
       // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setup {
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnTest:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"data"];
    [query whereKey:@"network" equalTo:@"viettel"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [object setObject:[NSNumber numberWithBool:_swViettel.isOn] forKey:@"isKm"];
        object[@"message"] = _txtViettel.text;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            PFQuery *query = [PFQuery queryWithClassName:@"data"];
            [query whereKey:@"network" equalTo:@"vina"];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                [object setObject:[NSNumber numberWithBool:_swVina.isOn] forKey:@"isKm"];
                object[@"message"] = _txtVina.text;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    PFQuery *query = [PFQuery queryWithClassName:@"data"];
                    [query whereKey:@"network" equalTo:@"mobi"];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                        [object setObject:[NSNumber numberWithBool:_swmobi.isOn] forKey:@"isKm"];
                        object[@"message"] = _txtMobi.text;
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            PFQuery *query = [PFQuery queryWithClassName:@"data"];
                            [query whereKey:@"network" equalTo:@"widget"];
                            [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                                [object setObject:[NSNumber numberWithBool:_swWidget.isOn] forKey:@"isKm"];
                                object[@"message"] = _txtWidget.text;
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                }];
                            }];
                        }]; }];
                }]; }];
        }]; }];
}


- (IBAction)btnSend:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFPush *push = [[PFPush alloc]init];
    NSDictionary *data = @{ @"alert" : _txtPush.text , @"badge" : @"Increment" };
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}
@end
