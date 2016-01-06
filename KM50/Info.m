//
//  Info.m
//  KM50
//
//  Created by Duy Quang on 1/6/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "Info.h"

@interface Info ()

@end

@implementation Info

- (void)viewDidLoad {
    _i = 0;
    self.navigationController.navigationBar.backItem.title = @" ";
    [super viewDidLoad];
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

- (IBAction)btnSetup:(id)sender {
    _i++;
    if(_i == 5) {
        _i =0;
            UIAlertController *al = [UIAlertController alertControllerWithTitle:@"Nhà Phát Triển" message:@"Dành cho nhà phát triển cập nhật dữ liệu lên Server. Người dùng không được cấp quyền vào mục này!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *no = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [al dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                PFQuery *querry = [PFQuery queryWithClassName:@"data"];
                [querry whereKey:@"network" equalTo:@"pass"];
                [querry getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {

                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if(!error) { if([al.textFields[0].text isEqualToString:object[@"message"]]) [self performSegueWithIdentifier:@"setup" sender:self];
                    } else [al dismissViewControllerAnimated:YES completion:nil];
                    }];
                }];
            [al addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"Nhập mật khẩu";
                textField.secureTextEntry = YES;
                textField.textColor = [UIColor redColor];
            }];
            [al addAction:no];
            [al addAction:ok];
            [self presentViewController:al animated:YES completion:nil];
        }
}
@end
