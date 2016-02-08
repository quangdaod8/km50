//
//  networkData.h
//  KM50
//
//  Created by Đào Duy Quang  on 1/4/16.
//  Copyright © 2016 Đào Duy Quang . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface networkData : NSObject

@property(strong, nonatomic) NSString* network;
@property(strong, nonatomic) NSString* message;
@property(strong, nonatomic) NSString* notnow;
@property(strong, nonatomic) NSString* detail;
@property(assign, nonatomic) BOOL isKm;

@end
