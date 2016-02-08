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
        netData.notnow = object[@"notnow"];
        netData.detail = object[@"detail"];
        [array addObject:netData];
            
        [query whereKey:@"network" equalTo:@"mobi"];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if(!error) {
                    networkData *netData = [[networkData alloc]init];
                    netData.isKm = [object[@"isKm"] boolValue];
                    netData.message = object[@"message"];
                    netData.network = @"mobi";
                    netData.notnow = object[@"notnow"];
                    netData.detail = object[@"detail"];
                    [array addObject:netData];
                    
                    [query whereKey:@"network" equalTo:@"viettel"];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if(!error) {
                            networkData *netData = [[networkData alloc]init];
                            netData.isKm = [object[@"isKm"] boolValue];
                            netData.message = object[@"message"];
                            netData.network = @"viettel";
                            netData.notnow = object[@"notnow"];
                            netData.detail = object[@"detail"];
                            [array addObject:netData];
                            
                            [query whereKey:@"network" equalTo:@"widget"];
                            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                if(!error) {
                                    networkData *netData = [[networkData alloc]init];
                                    netData.isKm = [object[@"isKm"] boolValue];
                                    netData.message = object[@"message"];
                                    netData.network = @"widget";
                                    netData.notnow = object[@"notnow"];
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
-(void)getInfoByNetwork:(NSString *)Network Completed:(blockCompleted)completed {
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"data"];
    [query whereKey:@"network" equalTo:Network];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error) {
            networkData *netData = [[networkData alloc]init];
            netData.isKm = [object[@"isKm"] boolValue];
            netData.message = object[@"message"];
            netData.network = Network;
            netData.notnow = object[@"notnow"];
            netData.detail = object[@"detail"];
            completed(netData,nil);
        } else {
            completed(nil,error);
        }
    }];
}
-(void)saveDataForNetwork:(NSString *)Network Message:(NSString *)message Detail:(NSString *)detail isKm:(BOOL)isKm Done:(blockOk)done {
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"data"];
    [query whereKey:@"network" equalTo:Network];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error) {
            object[@"message"] = message;
            object[@"detail"] = detail;
            [object setObject:[NSNumber numberWithBool:isKm] forKey:@"isKm"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(!error) done(nil);
                else done(error);
            }];
            
        } else {
            done(error);
        }
    }];
}

-(void)sendPushTestMessage:(NSString *)message Sent:(blockOk)sent {

    PFPush *push = [[PFPush alloc]init];
    NSDictionary *data = @{ @"alert" : message};
    PFQuery *query = [PFInstallation query];
    PFInstallation *install = [PFInstallation currentInstallation];
    [query whereKey:@"deviceToken" equalTo:install.deviceToken];
    [push setQuery:query];
    [push setData:data];
    [push expireAfterTimeInterval:86400];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded && !error) sent(nil);
        else sent(error);
    }];
}
-(void)sendPushToChannels:(NSArray *)channels Message:(NSString *)message Sent:(blockOk)sent {
    
    PFPush *push = [[PFPush alloc]init];
    NSDictionary *data = @{ @"alert" : message , @"badge" : @"Increment" };
    [push setData:data];
    [push setChannels:channels];
    [push expireAfterTimeInterval:86400];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded && !error) sent(nil);
        else sent(error);
    }];
}
@end
