//
//  UIDevice+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLTypedefs.h"

@interface UIDevice (IDLNetwork)

- (NSDictionary *)IPAddresses;

- (NSString *)wifiIPAddress;

@end

@interface UIDevice (IDLScreen)

- (CGSize)screenSize;
- (CGFloat)screenScale;

- (BOOL)screenIsWide;

@end

@interface UIDevice (IDLSystem)

- (NSString *)deviceModelID;
- (IDLSystemVersion)deviceSystemVersion;

@end

#define UIDeviceCurrentDeviceSystemVersion      [UIDevice currentDevice].deviceSystemVersion

