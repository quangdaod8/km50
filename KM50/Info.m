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
    
    _btnAva.clipsToBounds = YES;
    _btnAva.layer.borderWidth = 0.5;
    _btnAva.layer.cornerRadius = 50;
    _btnAva.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _i = 0;
    self.navigationController.navigationBar.backItem.title = @" ";
    UIBarButtonItem *gop = [[UIBarButtonItem alloc]initWithTitle:@"Liên Hệ" style:UIBarButtonItemStylePlain target:self action:@selector(gopy)];
    self.navigationItem.rightBarButtonItem = gop;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)gopy {
    UIAlertController *lh = [UIAlertController alertControllerWithTitle:@"" message:@"Liên hệ với Tác Giả" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *huy = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [lh dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *sms = [UIAlertAction actionWithTitle:@"Gửi Tin Nhắn" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *tin = [[MFMessageComposeViewController alloc]init];
            [tin setRecipients:[NSArray arrayWithObject:@"+841632652615"]];
            [tin setBody:@""];
            tin.messageComposeDelegate = self;
            [self presentViewController:tin animated:YES completion:nil];
        } else [self AlertWithTitle:@"Lỗi" Messenger:@"Không thể gửi tin nhắn trên thiết bị này" Butontitle:@"Ok"];
    }];
    
    UIAlertAction *mail = [UIAlertAction actionWithTitle:@"Gửi Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
            [mail setSubject:@"Xin chào KM50"];
            [mail setToRecipients:[NSArray arrayWithObject:@"daoduyquang91@gmail.com"]];
            [mail setMessageBody:@"" isHTML:NO];
            mail.mailComposeDelegate = self;
            [self presentViewController:mail animated:YES completion:nil];
        } else [self AlertWithTitle:@"Lỗi" Messenger:@"Vui lòng kiểm tra cài đặt Email" Butontitle:@"Ok"];
    }];
    
    UIAlertAction *fb = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *urlApp = [NSURL URLWithString:@"fb://profile/quangmin91"];
        NSURL *urlSa = [NSURL URLWithString:@"https://www.facebook.com/quangmin91"];
        if ([[UIApplication sharedApplication] canOpenURL:urlApp]) [[UIApplication sharedApplication] openURL:urlApp];
        else [[UIApplication sharedApplication] openURL:urlSa];
    }];
    [lh addAction:sms];
    [lh addAction:mail];
    [lh addAction:fb];
    [lh addAction:huy];
    
    UIPopoverPresentationController *popPresenter = [lh popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = _btnAva.frame;
    
    [self presentViewController:lh animated:YES completion:nil];
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

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

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
                [querry whereKey:@"network" equalTo:@"web"];
                [querry getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {

                    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
