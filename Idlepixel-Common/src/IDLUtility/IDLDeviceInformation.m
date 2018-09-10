//
//  IDLDeviceInformation.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 12/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLDeviceInformation.h"
#import "NSObject+Idlepixel.h"

#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/stat.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <unistd.h>
#import <objc/runtime.h>

#define IFT_ETHER 0x6

NSString * const kDeviceWiFiInterfaceName = @"en0";

@implementation IDLDeviceInformation

+ (NSDictionary *)IPAddresses
{
    
    NSString *name = nil;
    NSString *address = nil;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *currentInterface = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        currentInterface = interfaces;
        while(currentInterface != NULL) {
            if(currentInterface->ifa_addr->sa_family == AF_INET) {
                name = [NSString stringWithUTF8String:currentInterface->ifa_name];
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)currentInterface->ifa_addr)->sin_addr)];
                if (name != nil) [dictionary setObject:address forKey:name];
            }
            currentInterface = currentInterface->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return dictionary;
}

+ (NSString *)wifiIPAddress
{
    NSDictionary *addresses = [self IPAddresses];
    NSString *address = [addresses objectForKey:kDeviceWiFiInterfaceName];
    return address;
}

+ (NSString *)deviceModelID
{
    static NSString *deviceModelID = nil;
    
    if (deviceModelID == nil) {
        int mib[2];
        size_t len;
        char* machine = NULL;
        
        mib[0] = CTL_HW;
        mib[1] = HW_MACHINE;
        sysctl(mib, 2, NULL, &len, NULL, 0);
        machine = malloc(len);
        sysctl(mib, 2, machine, &len, NULL, 0);
        deviceModelID = [NSString stringWithCString: machine encoding: NSASCIIStringEncoding];
        free(machine);
    }
    return deviceModelID;
}

#pragma mark - support

+ (BOOL) supportsOpenGLES2
{
    static NSNumber *supported;
    
    if (supported == nil) {
        EAGLContext *context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
        supported = [NSNumber numberWithBool:(context != nil)];
    }
    
    return supported.boolValue;
}

+ (BOOL) supportsPhone
{
    static NSNumber *supported;
    
    if (supported == nil) {
        supported = [NSNumber numberWithBool:[[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: @"tel://0123456789"]]];
    }
    
    return supported.boolValue;
}

@end
