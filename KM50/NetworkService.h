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
typedef void (^blockCompleted) (networkData *networkData, NSError* error);
typedef void (^blockOk) (NSError* error);
@interface NetworkService : NSObject

-(void)getDataForArray:(blockDone)completed;
-(void)getInfoByNetwork:(NSString*)Network Completed:(blockCompleted) completed;
-(void)saveDataForNetwork:(NSString*)Network Message:(NSString*)message Detail:(NSString*)detail isKm:(BOOL)isKm Done:(blockOk)done;
-(void)sendPushToChannels:(NSArray*)channels Message:(NSString*)message Sent:(blockOk)sent;
-(void)sendPushTestMessage:(NSString*)message Sent:(blockOk)sent;

@end
