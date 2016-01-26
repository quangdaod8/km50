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
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    self.bannerView.adUnitID = @"ca-app-pub-9719677587937425/2666256995";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ @"6bccd7746cf0ea0584ba0e7444001644" ];
    [self.bannerView loadRequest:request];
    
    NSUserDefaults *isfirst = [NSUserDefaults standardUserDefaults];
    if(![isfirst boolForKey:@"isfirst"]) {
        NSArray *channels = [NSArray arrayWithObjects:@"viettel", @"mobifone", @"vinaphone", nil];
        PFInstallation *install = [PFInstallation currentInstallation];
        [install setChannels:channels];
        [install saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [isfirst setBool:YES forKey:@"isfirst"];
            [isfirst synchronize];
        }];
    }

    self.navigationItem.title = @"KM50";
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [self AlertWithTitle:@"Cho Phép Thông Báo" Messenger:@"Vui lòng cho phép thông báo để hệ thống có thể tự động gửi thông báo ngay khi có chương trình khuyến mãi" Butontitle:@"Ok"];
    } 

    UIBarButtonItem *info = [[UIBarButtonItem alloc]initWithTitle:@"Cài Đặt" style:UIBarButtonItemStylePlain  target:self action:@selector(info)];
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
            if(error.code == 100) [self AlertWithTitle:@"Lỗi Kết Nối" Messenger:@"Vui lòng kiểm tra kết nối Internet." Butontitle:@"Ok"]; else {
                NSString *s = [NSString stringWithFormat:@"Vui lòng cung cấp mã lỗi này cho nhà phát triển:\nERROR_CODE: %@",error.localizedDescription];
                [self AlertWithTitle:@"Lỗi Kết Nối" Messenger:s Butontitle:@"Ok"];
            }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    UIAlertController *menu = [UIAlertController alertControllerWithTitle:@"Cài Đặt" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *huy = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [menu dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *tuy = [UIAlertAction actionWithTitle:@"Tuỳ Chọn Thông Báo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"tuychon" sender:self];
    }];
    UIAlertAction *info = [UIAlertAction actionWithTitle:@"Thông Tin" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"info" sender:self];
    }];
    UIAlertAction *gop = [UIAlertAction actionWithTitle:@"Quyên Góp" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"gop" sender:self];
    }];

    [menu addAction:tuy];
    [menu addAction:info];
    [menu addAction:gop];
    [menu addAction:huy];
    [self presentViewController:menu animated:YES completion:nil];
    
}

- (IBAction)btnFb:(id)sender {
    NSURL *urlApp = [NSURL URLWithString:@"fb://profile/1130451813656422"];
    NSURL *urlSa = [NSURL URLWithString:@"https://www.facebook.com/km50app"];
    if ([[UIApplication sharedApplication] canOpenURL:urlApp]) [[UIApplication sharedApplication] openURL:urlApp];
    else [[UIApplication sharedApplication] openURL:urlSa];
}

@end
