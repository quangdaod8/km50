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
    [super viewDidLoad];
    _service = [[NetworkService alloc]init];
    _url = @"http://km50.blogspot.com";
    
    _header.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _header.layer.borderWidth = 0.5;
    [_tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    self.bannerView.adUnitID = @"ca-app-pub-9719677587937425/2666256995";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ @"d16c9931688b304bfc891242ed02c3c3" ];
    [self.bannerView loadRequest:request];
    _bannerView.hidden = YES;
    
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
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            [self AlertWithTitle:@"Cho Phép Thông Báo" Messenger:@"Vui lòng cho phép thông báo để hệ thống có thể tự động gửi thông báo ngay khi có chương trình khuyến mãi" Butontitle:@"Ok"];
        }

    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(!(types & UIRemoteNotificationTypeAlert)) {
            [self AlertWithTitle:@"Cho Phép Thông Báo" Messenger:@"Vui lòng cho phép thông báo để hệ thống có thể tự động gửi thông báo ngay khi có chương trình khuyến mãi" Butontitle:@"Ok"];
        }
    }

    UIBarButtonItem *info = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(info)];
    self.navigationItem.leftBarButtonItem = info;
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
        
    UIBarButtonItem *wg = [[UIBarButtonItem alloc]initWithTitle:@"Cài widget" style:UIBarButtonItemStylePlain  target:self action:@selector(widget)];
    self.navigationItem.rightBarButtonItem = wg;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    _array = [[NSArray alloc]init];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.backgroundColor = [UIColor whiteColor];
    [_tableView setUserInteractionEnabled:NO];
    
    [_service getDataForArray:^(NSArray *data, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        if(!error) {
            _array = [NSArray arrayWithArray:data];
            [_tableView reloadData];
            _bannerView.hidden = NO;
            [_tableView setUserInteractionEnabled:YES];
        }
        else {
            if(error.code == 100) [self AlertWithTitle:@"Lỗi Kết Nối" Messenger:@"Vui lòng kiểm tra kết nối Internet." Butontitle:@"Ok"]; else {
                [self AlertWithTitle:@"Quá Tải" Messenger:@"Hệ thống quá tải do có quá nhiều người dùng truy cập cùng lúc. Vui lòng thử lại trong chốc lát." Butontitle:@"Ok"];
            }
        }
    }];
    
    [_service getWebUrl:^(networkData *networkData, NSError *error) {
        if(!error) _url = networkData.detail;
    }];
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
    if(_array.count > 0) {
        networkData *data = [[networkData alloc]init];
        data = (networkData*)_array[indexPath.row];
        [cell setDataByNetworkData:data];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:indexPath];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    networkData *data = [[networkData alloc]init];
    data = _array[indexPath.row];
    UITableViewRowAction *share = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Chia Sẻ" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSString *string = data.message;
        NSURL *url = [NSURL URLWithString:_url];
            UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:@[string,url] applicationActivities:nil];
        [self presentViewController:share animated:YES completion:^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }];
    }];
    share.backgroundColor = [UIColor greenColor];
    return @[share];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath *index = (NSIndexPath*)sender;
        Detail *detailVC = segue.destinationViewController;
        detailVC.detail = _array[index.row];
    }
}

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    if ([UIAlertController class]) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:messenger delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
        [alert show];
    }
}

-(void)widget {
    [self performSegueWithIdentifier:@"wg" sender:self];
}

-(void)info {
    [self performSegueWithIdentifier:@"caidat" sender:self];
}



@end
