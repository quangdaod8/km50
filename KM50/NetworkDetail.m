//
//  NetworkDetail.m
//  KM50
//
//  Created by Duy Quang on 2/8/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "NetworkDetail.h"

@interface NetworkDetail ()

@end

@implementation NetworkDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _network;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Lưu" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    _txtNetwork.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _txtNetwork.layer.borderWidth = 1;
    
    _txtNetworkDetail.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _txtNetworkDetail.layer.borderWidth = 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _service = [[NetworkService alloc]init];
    
    [_service getInfoByNetwork:_network Completed:^(networkData *networkData, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!error) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        _txtNetwork.text = networkData.message;
        _txtNetworkDetail.text = networkData.detail;
        [_swisKm setOn:networkData.isKm animated:YES];
        } else [self AlertWithTitle:@"Lỗi" Messenger:[error localizedDescription] Butontitle:@"Ok"];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)save {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_service saveDataForNetwork:_network Message:_txtNetwork.text Detail:_txtNetworkDetail.text isKm:_swisKm.isOn Done:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!error) [self AlertWithTitle:@"Xong" Messenger:@"Đã lưu" Butontitle:@"Ok"];
        else [self AlertWithTitle:@"Error" Messenger:[error localizedDescription] Butontitle:@"Ok"];
    }];
}

- (IBAction)swisKmPress:(id)sender {
}
@end
