//
//  Push.m
//  KM50
//
//  Created by Duy Quang on 2/8/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "Push.h"

@interface Push ()

@end

@implementation Push

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _service = [[NetworkService alloc]init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"GỬI" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    _txtMessage.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _txtMessage.layer.borderWidth = 1;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)send {

    if(!_swMobi.isOn && !_swVina.isOn && !_swViettel.isOn)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_service sendPushTestMessage:_txtMessage.text Sent:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(error) [self AlertWithTitle:@"Error" Messenger:[error localizedDescription] Butontitle:@"Ok"];
    }];
    }else {
        
        NSMutableArray *channels = [[NSMutableArray alloc]init];
        if(_swMobi.isOn) [channels addObject:@"mobifone"];
        if(_swViettel.isOn) [channels addObject:@"viettel"];
        if(_swVina.isOn) [channels addObject:@"vinaphone"];
        
        NSString *s = [[NSString alloc]init];
        for(int i = 0; i < channels.count; i++) s = [s stringByAppendingString:[NSString stringWithFormat:@"%@, ", channels[i]]];
        s = [NSString stringWithFormat:@"Thông báo này sẽ được gửi đến các thiết bị đăng ký nhà mạng: %@",s];
        
        UIAlertController *noti = [UIAlertController alertControllerWithTitle:@"Xác Nhận" message:s preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *gui = [UIAlertAction actionWithTitle:@"GỬI" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [_service sendPushToChannels:channels Message:_txtMessage.text Sent:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(error) [self AlertWithTitle:@"Error" Messenger:error.localizedDescription Butontitle:@"Ok"];
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

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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
