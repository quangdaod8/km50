//
//  Detail.m
//  KM50
//
//  Created by Duy Quang on 2/3/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "Detail.h"

@interface Detail ()

@end

@implementation Detail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([_detail.network isEqualToString:@"vina"]) self.navigationItem.title = @"Vinaphone";
    if([_detail.network isEqualToString:@"mobi"]) self.navigationItem.title = @"Mobifone";
    if([_detail.network isEqualToString:@"viettel"]) self.navigationItem.title = @"Viettel";
    
    if(_detail.isKm) {
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.navigationItem.backBarButtonItem setEnabled:NO];
        
    _banner.adUnitID = @"ca-app-pub-9719677587937425/7906074995";
    _banner.rootViewController = self;
    GADRequest *request1 = [[GADRequest alloc]init];
    //request1.testDevices = @[ @"d16c9931688b304bfc891242ed02c3c3" ];
    [self.banner loadRequest:request1];
    _banner.hidden = YES;
        
    _full = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-9719677587937425/7347671791"];
    GADRequest *request = [[GADRequest alloc]init];
    //request.testDevices = @[ @"d16c9931688b304bfc891242ed02c3c3" ];
    [_full loadRequest:request];
    _full.delegate = self;
        
        UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
        self.navigationItem.rightBarButtonItem = share;
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
    } else {
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [_textField.font fontWithSize:15];
        _textField.text = [NSString stringWithFormat:@"\n%@", _detail.notnow];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [ad presentFromRootViewController:self];
}
-(void)interstitialDidDismissScreen:(GADInterstitial *)ad {
     _textField.text = _detail.detail;
    _banner.hidden = NO;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationItem.backBarButtonItem setEnabled:YES];
}
-(void)share {
    UIAlertController *share = [UIAlertController alertControllerWithTitle:@"" message:@"Chia sẻ tin khuyến mãi" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *huy = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [share dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *sms = [UIAlertAction actionWithTitle:@"Gửi Tin Nhắn" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *tin = [[MFMessageComposeViewController alloc]init];
        [tin setBody:_detail.message];
        tin.messageComposeDelegate = self;
        [self presentViewController:tin animated:YES completion:nil];
        } else [self AlertWithTitle:@"Lỗi" Messenger:@"Không thể gửi tin nhắn trên thiết bị này" Butontitle:@"Ok"];
    }];
    UIAlertAction *copy = [UIAlertAction actionWithTitle:@"Sao Chép" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *paster = [UIPasteboard generalPasteboard];
        paster.string = _detail.message;
        [self AlertWithTitle:@"Xong" Messenger:@"Đã sao chép vào bộ nhớ đệm." Butontitle:@"Ok"];
    }];
    UIAlertAction *email = [UIAlertAction actionWithTitle:@"Gửi Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
            [mail setSubject:_detail.message];
            [mail setMessageBody:_detail.detail isHTML:NO];
            mail.mailComposeDelegate = self;
            [self presentViewController:mail animated:YES completion:nil];
        } else [self AlertWithTitle:@"Lỗi" Messenger:@"Vui lòng kiểm tra cài đặt Email" Butontitle:@"Ok"];
    }];

    [share addAction:sms];
    [share addAction:email];
    [share addAction:copy];
    [share addAction:huy];
    [self presentViewController:share animated:YES completion:nil];
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

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
