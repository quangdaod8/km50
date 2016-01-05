//
//  NetworkService.h
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "networkData.h"
#import <Parse/Parse.h>

typedef void (^blockDone) (NSArray *data,NSError* error);

@interface NetworkService : NSObject

-(void)getDataForArray:(blockDone)completed;

@end
