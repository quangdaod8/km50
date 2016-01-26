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
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"Lưu" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = save;
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
    PFPush *push = [[PFPush alloc]init];
    NSDictionary *data = @{ @"alert" : _txtPush.text};
    PFQuery *query = [PFInstallation query];
    PFInstallation *install = [PFInstallation currentInstallation];
    [query whereKey:@"deviceToken" equalTo:install.deviceToken];
    [push setQuery:query];
    [push setData:data];
    [push expireAfterTimeInterval:86400];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

   }


- (IBAction)btnSend:(id)sender {
    PFPush *push = [[PFPush alloc]init];
    NSDictionary *data = @{ @"alert" : _txtPush.text , @"badge" : @"Increment" };
    [push setData:data];
    
    NSMutableArray *channels = [[NSMutableArray alloc]init];
    if(_swmobi.isOn) [channels addObject:@"mobifone"];
    if(_swViettel.isOn) [channels addObject:@"viettel"];
    if(_swVina.isOn) [channels addObject:@"vinaphone"];
    if(channels.count > 0) {
        
        NSString *s = [[NSString alloc]init];
        for(int i = 0; i < channels.count; i++) s = [s stringByAppendingString:[NSString stringWithFormat:@"%@, ", channels[i]]];
        s = [NSString stringWithFormat:@"Thông báo này sẽ được gửi đến các thiết bị đăng ký nhà mạng: %@",s];
        
        UIAlertController *noti = [UIAlertController alertControllerWithTitle:@"Xác Nhận" message:s preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *gui = [UIAlertAction actionWithTitle:@"GỬI" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [push setChannels:channels];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        }];
        
        UIAlertAction *huy = [UIAlertAction actionWithTitle:@"HUỶ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [noti dismissViewControllerAnimated:YES completion:nil];
        }];
        [noti addAction:gui];
        [noti addAction:huy];
        [self presentViewController:noti animated:YES completion:nil];
    }else {
        UIAlertController *noti = [UIAlertController alertControllerWithTitle:@"Cảnh Báo" message:@"Thông báo này sẽ được gửi đến tất cả các thiêt bị! Bạn có chắc chắn không?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *gui = [UIAlertAction actionWithTitle:@"GỬI ĐẾN TẤT CẢ CÁC THIẾT BỊ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }];
        UIAlertAction *huy = [UIAlertAction actionWithTitle:@"HUỶ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [noti dismissViewControllerAnimated:YES completion:nil];
        }];
        [noti addAction:gui];
        [noti addAction:huy];
        [self presentViewController:noti animated:YES completion:nil];
    }
}
-(void)saveData {
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
@end
