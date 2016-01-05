//
//  ViewController.m
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {

    self.navigationItem.title = @"KM50";

    UIBarButtonItem *setup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(setup)];
    self.navigationItem.rightBarButtonItem = setup;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    UIBarButtonItem *info = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(info)];
    self.navigationItem.leftBarButtonItem = info;
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    _btnWidget.clipsToBounds = YES;
    _btnWidget.layer.cornerRadius = 5;
    
    _array = [[NSArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetworkService *service = [[NetworkService alloc]init];
    [service getDataForArray:^(NSArray *data, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            _array = [NSArray arrayWithArray:data];
            [_tableView reloadData];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [self.navigationItem.leftBarButtonItem setEnabled:YES];
        }
        else {
            [self AlertWithTitle:@"Lỗi Mạng" Messenger:@"Vui lòng kiểm tra kết nối Internet." Butontitle:@"Ok"];
        }
    }];
    
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CustomCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(_array.count > 0) [cell setDataByNetworkData:_array[indexPath.row]];
    return cell;
}

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)setup {
    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"Nhà Phát Triển" message:@"Dành cho nhà phát triển cập nhật dữ liệu lên Server. Người dùng không được cấp quyền vào mục này!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [al dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PFQuery *querry = [PFQuery queryWithClassName:@"data"];
        [querry whereKey:@"network" equalTo:@"pass"];
        [querry getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
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
- (IBAction)btnWidgetPress:(id)sender {
}
-(void)info {
    [self performSegueWithIdentifier:@"info" sender:self];
}
@end
