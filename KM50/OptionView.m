//
//  OptionView.m
//  KM50
//
//  Created by Duy Quang on 1/22/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "OptionView.h"

@interface OptionView ()

@end

@implementation OptionView

- (void)viewDidLoad {
    [super viewDidLoad];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFInstallation *install = [PFInstallation currentInstallation];
    NSArray *channels = [NSArray arrayWithArray:[install channels]];
    if([channels containsObject:@"viettel"]) [_swViettel setOn:YES animated:YES];
    if([channels containsObject:@"mobifone"]) [_swMobi setOn:YES animated:YES];
    if([channels containsObject:@"vinaphone"]) [_swVina setOn:YES animated:YES];
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"Lưu" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = save;
}

-(void)save {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *channels = [[NSMutableArray alloc]init];
    if(_swViettel.isOn) [channels addObject:@"viettel"];
    if(_swMobi.isOn) [channels addObject:@"mobifone"];
    if(_swVina.isOn) [channels addObject:@"vinaphone"];
    PFInstallation *install = [PFInstallation currentInstallation];
    [install setChannels:channels];
    [install saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            UIAlertController *done = [UIAlertController alertControllerWithTitle:@"Đã Lưu" message:@"Đã lưu trạng thái đăng ký thành công" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [done dismissViewControllerAnimated:YES completion:nil];
            }];
            [done addAction:ok];
            [self presentViewController:done animated:YES completion:nil];
        } else {
            NSString *s = [NSString stringWithFormat:@"Vui lòng cung cấp mã lỗi này cho nhà phát triển:\nERROR_CODE: %@",error.localizedDescription];
            UIAlertController *loi = [UIAlertController alertControllerWithTitle:@"Lỗi" message:s preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [loi dismissViewControllerAnimated:YES completion:nil];
            }];
            [loi addAction:ok];
            [self presentViewController:loi animated:YES completion:nil];

        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
