//
//  Admin.h
//  KM50
//
//  Created by Duy Quang on 2/6/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDetail.h"

@interface Admin : UITableViewController<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSArray* data;

@end
