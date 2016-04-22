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
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(_detail.isKm) {
        _textField.text = _detail.detail;
        
        _banner.adUnitID = @"ca-app-pub-9719677587937425/7906074995";
        _banner.rootViewController = self;
        GADRequest *request1 = [[GADRequest alloc]init];
        //request1.testDevices = @[ @"d16c9931688b304bfc891242ed02c3c3" ];
        [self.banner loadRequest:request1];
        
        _full = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-9719677587937425/7347671791"];
        GADRequest *request = [[GADRequest alloc]init];
        //request.testDevices = @[ @"d16c9931688b304bfc891242ed02c3c3" ];
        [_full loadRequest:request];
        _full.delegate = self;
        
        UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
        self.navigationItem.rightBarButtonItem = share;
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"Xong" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = back;
        
    } else {
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.text = [NSString stringWithFormat:@"\n%@", _detail.notnow];
        
        _banner.adUnitID = @"ca-app-pub-9719677587937425/7906074995";
        _banner.rootViewController = self;
        GADRequest *request1 = [[GADRequest alloc]init];
        //request1.testDevices = @[ @"d16c9931688b304bfc891242ed02c3c3" ];
        [self.banner loadRequest:request1];
        
        _full = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-9719677587937425/7347671791"];
        GADRequest *request = [[GADRequest alloc]init];
        //request.testDevices = @[ @"d16c9931688b304bfc891242ed02c3c3" ];
        [_full loadRequest:request];
        _full.delegate = self;
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"Xong" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = back;
    }

}

-(void)back {
    if(_full.isReady) [_full presentFromRootViewController:self];
    else [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)share {
    UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:@[_detail.detail] applicationActivities:nil];
    
    UIPopoverPresentationController *popPresenter = [share popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = self.navigationController.navigationBar.frame;
    
    [self presentViewController:share animated:YES completion:nil];
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
