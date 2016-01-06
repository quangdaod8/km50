//
//  ViewController.h
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "NetworkService.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;

@property (weak, nonatomic) IBOutlet UIButton *btnWidget;

- (IBAction)btnWidgetPress:(id)sender;
@end
