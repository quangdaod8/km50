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
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [self AlertWithTitle:@"Cho Phép Thông Báo" Messenger:@"Vui lòng cho phép thông báo để hệ thống có thể tự động gửi thông báo ngay khi có chương trình khuyến mãi" Butontitle:@"Ok"];
    } 

    UIBarButtonItem *info = [[UIBarButtonItem alloc]initWithTitle:@"Thông tin" style:UIBarButtonItemStylePlain  target:self action:@selector(info)];
    self.navigationItem.leftBarButtonItem = info;
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
        
    UIBarButtonItem *wg = [[UIBarButtonItem alloc]initWithTitle:@"Cài Widget" style:UIBarButtonItemStylePlain  target:self action:@selector(widget)];
    self.navigationItem.rightBarButtonItem = wg;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    _array = [[NSArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetworkService *service = [[NetworkService alloc]init];
    [service getDataForArray:^(NSArray *data, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        if(!error) {
            _array = [NSArray arrayWithArray:data];
            [_tableView reloadData];
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

-(void)widget {
    [self performSegueWithIdentifier:@"wg" sender:self];
}
-(void)info {
    [self performSegueWithIdentifier:@"info" sender:self];
}

@end
