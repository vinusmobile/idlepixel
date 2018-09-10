//
//  IDLPhoneManager.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 16/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLPhoneManager.h"
#import "IDLDeviceInformation.h"
#import "NSString+Idlepixel.h"

#define kPhonePrefix @"tel://"

@implementation IDLPhoneManager

+(instancetype)sharedManager
{
    return [self preferredSingleton];
}

-(void)callPhoneNumber:(NSString *)phoneNumber
{
    if (self.supportsPhoneCalls) {
        phoneNumber = [phoneNumber stringByStrippingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (phoneNumber.length > 0) {
            if (![phoneNumber hasPrefix:kPhonePrefix]) {
                phoneNumber = [phoneNumber stringByAddingPrefix:kPhonePrefix];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    }
}

-(BOOL)supportsPhoneCalls
{
    return [IDLDeviceInformation supportsPhone];
}

+(BOOL)supportsPhoneCalls
{
    return [[self sharedManager] supportsPhoneCalls];
}

@end
