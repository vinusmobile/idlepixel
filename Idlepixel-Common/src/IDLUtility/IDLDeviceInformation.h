//
//  IDLDeviceInformation.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 12/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kDeviceWiFiInterfaceName;

@interface IDLDeviceInformation : NSObject

+ (NSDictionary *)IPAddresses;

+ (NSString *)wifiIPAddress;

+ (NSString *)deviceModelID;

// support

+ (BOOL) supportsOpenGLES2;
+ (BOOL) supportsPhone;

@end
