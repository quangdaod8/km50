//
//  NetworkService.m
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService

-(void)getDataForArray:(blockDone)completed {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"data"];
    [query whereKey:@"network" equalTo:@"vina"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error) {
        networkData *netData = [[networkData alloc]init];
        netData.isKm = [object[@"isKm"] boolValue];
        netData.message = object[@"message"];
        netData.network = @"vina";
        [array addObject:netData];
            
        [query whereKey:@"network" equalTo:@"mobi"];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if(!error) {
                    networkData *netData = [[networkData alloc]init];
                    netData.isKm = [object[@"isKm"] boolValue];
                    netData.message = object[@"message"];
                    netData.network = @"mobi";
                    [array addObject:netData];
                    
                    [query whereKey:@"network" equalTo:@"viettel"];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if(!error) {
                            networkData *netData = [[networkData alloc]init];
                            netData.isKm = [object[@"isKm"] boolValue];
                            netData.message = object[@"message"];
                            netData.network = @"viettel";
                            [array addObject:netData];
                            
                            [query whereKey:@"network" equalTo:@"widget"];
                            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                if(!error) {
                                    networkData *netData = [[networkData alloc]init];
                                    netData.isKm = [object[@"isKm"] boolValue];
                                    netData.message = object[@"message"];
                                    netData.network = @"widget";
                                    [array addObject:netData];
                                    completed(array,nil);
                                } else completed(nil,error);
                            }];
                        } else completed(nil,error);
                    }];
                    
                } else completed(nil,error);
        }];
        } else completed(nil,error);
    }];
    
}
@end
