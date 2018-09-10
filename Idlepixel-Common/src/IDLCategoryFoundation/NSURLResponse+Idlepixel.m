//
//  NSURLResponse+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSURLResponse+Idlepixel.h"
#import "NSDate+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"

NSString * const kURLResponseHTTPHeaderFieldDate = @"date";

@implementation NSURLResponse (IDLHTTPDate)

-(NSDate *)responseDate
{
    NSString *dateString = nil;
    
    if ([self isKindOfClass:[NSHTTPURLResponse class]]) {
        NSDictionary *headerFields = [(NSHTTPURLResponse *)self allHeaderFields];
        dateString = [headerFields valueForCaseInsensitiveKey:kURLResponseHTTPHeaderFieldDate];
    }
    
    if ([dateString isKindOfClass:[NSString class]] && [dateString length] > 0) {
        return [NSDate dateWithHTTPDate:dateString];
    } else {
        return nil;
    }
}

@end
