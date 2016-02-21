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
    
    _header.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _header.layer.borderWidth = 0.5;

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
            [isfirst setBool:YES forKey:@"isfirst"];
            [isfirst synchronize];
        }];
    }

    self.navigationItem.title = @"KM50";
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [self AlertWithTitle:@"Cho Phép Thông Báo" Messenger:@"Vui lòng cho phép thông báo để hệ thống có thể tự động gửi thông báo ngay khi có chương trình khuyến mãi" Butontitle:@"Ok"];
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
    
    NetworkService *service = [[NetworkService alloc]init];
    [service getDataForArray:^(NSArray *data, NSError *error) {
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(_array.count > 0) [cell setDataByNetworkData:_array[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:indexPath];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *modifyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Gửi Tin" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *tin = [[MFMessageComposeViewController alloc]init];
            networkData *data = [[networkData alloc]init];
            data = _array[indexPath.row];
            if(data.isKm) [tin setBody:data.message];
            else [tin setBody:data.notnow];
            tin.messageComposeDelegate = self;
            [self presentViewController:tin animated:YES completion:^{
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            }];
        } else [self AlertWithTitle:@"Lỗi" Messenger:@"Không thể gửi tin nhắn trên thiết bị này" Butontitle:@"Ok"];
    }];
    modifyAction.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *copy = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Copy" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIPasteboard *paster = [UIPasteboard generalPasteboard];
        networkData *data = [[networkData alloc]init];
        data = _array[indexPath.row];
        paster.string = data.message;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sao Chép" message:@"Đã sao chép vào bộ nhớ đệm." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    copy.backgroundColor = [UIColor lightGrayColor];
    
    return @[modifyAction,copy];
    
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)widget {
    [self performSegueWithIdentifier:@"wg" sender:self];
}

-(void)info {
    [self performSegueWithIdentifier:@"caidat" sender:self];
}



@end
