//
//  UIDevice+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIDevice+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "IDLDeviceInformation.h"
#import "IDLNSInlineExtensions.h"

@implementation UIDevice (IDLNetwork)

- (NSDictionary *)IPAddresses
{
    return [IDLDeviceInformation IPAddresses];
}

- (NSString *)wifiIPAddress
{
    return [IDLDeviceInformation wifiIPAddress];
}

@end

@implementation UIDevice (IDLScreen)

- (CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}

- (CGFloat)screenScale
{
    return [UIScreen mainScreen].scale;
}

- (BOOL)screenIsWide
{
    return (self.userInterfaceIdiom == UIUserInterfaceIdiomPhone && self.screenSize.height > 480.0f);
}

@end

@implementation UIDevice (IDLSystem)

- (NSString *)deviceModelID
{
    return [IDLDeviceInformation deviceModelID];
}

- (IDLSystemVersion)deviceSystemVersion
{
    static IDLSystemVersion deviceSystemVersion = IDLVersionZero;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *versionString = [[UIDevice currentDevice] systemVersion];
        deviceSystemVersion = IDLVersionFromString(versionString);
    });
    return deviceSystemVersion;
}

@end
