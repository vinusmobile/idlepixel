//
//  NSDate+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSDate+Idlepixel.h"

NSString * const kHTTPDateTimeZone                  = @"GMT";
NSString * const kHTTPDateLocale                    = @"en_US";

NSString * const kHTTPDateFormatRFC1123             = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
NSString * const kHTTPDateFormatRFC850              = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
NSString * const kHTTPDateFormatANSI_C              = @"EEE MMM d HH':'mm':'ss yyyy";

NSString * const kHTTPDateFormatPostgres            = @"yyyy'-'MM'-'dd HH':'mm':'ss z";
NSString * const kHTTPDateFormatPostgresMS          = @"yyyy'-'MM'-'dd HH':'mm':'ss'.'SSSSSS z";
NSString * const kHTTPDateFormatPostgresT           = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
NSString * const kHTTPDateFormatPostgresDateOnly    = @"yyyy'-'MM'-'dd";


//*/
//
// Category on NSDate to support HTTP (RFC1123, RFC850, ANSI_C) formatted date strings.
// Adapted from:
//    - http://blog.mro.name/2009/08/nsdateformatter-http-header/
//    - http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
//
//*/

@implementation NSDate (IDLHTTPDate)

+ (NSDate*) dateWithHTTPDate: (NSString*) value_
{
    if(value_ == nil) return nil;
    
    NSDate *date = nil;
    
    // check for RFC1123 format
    date = [self dateWithRFC1123Date:value_];
    
    // check for RFC850 format
    if (date == nil) {
        date = [self dateWithRFC850Date:value_];
    }
    
    // check for ANSI C format
    if (date == nil) {
        date = [self dateWithANSICDate:value_];
    }
    
    // check for Postgres format
    if (date == nil) {
        date = [self dateWithPostgresDate:value_];
    }
    
    return date;
}

+ (NSDateFormatter *)standardDateFormatter
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:kHTTPDateLocale];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:kHTTPDateTimeZone];
    return formatter;
}

+ (NSDate *)dateWithRFC1123Date: (NSString*) httpDate
{
    NSDateFormatter *formatter = [self standardDateFormatter];
    // check for RFC1123 format
    formatter.dateFormat = kHTTPDateFormatRFC1123;
    return [formatter dateFromString:httpDate];
}

+ (NSDate *)dateWithRFC850Date: (NSString*) httpDate
{
    NSDateFormatter *formatter = [self standardDateFormatter];
    // check for RFC850 format
    formatter.dateFormat = kHTTPDateFormatRFC850;
    return [formatter dateFromString:httpDate];
}

+ (NSDate *)dateWithANSICDate: (NSString*) httpDate
{
    NSDateFormatter *formatter = [self standardDateFormatter];
    // check for ANSI C format
    formatter.dateFormat = kHTTPDateFormatANSI_C;
    return [formatter dateFromString:httpDate];
}

+ (NSDate *)dateWithPostgresDate: (NSString*) httpDate
{
    NSDateFormatter *formatter = [self standardDateFormatter];
    // check for Postgres format
    formatter.dateFormat = kHTTPDateFormatPostgres;
    NSDate *date = [formatter dateFromString:httpDate];
    
    // check for Postgres+MS format
    if (date == nil) {
        formatter.dateFormat = kHTTPDateFormatPostgresMS;
        date = [formatter dateFromString:httpDate];
    }
    
    // check for PostgresT format
    if (date == nil) {
        formatter.dateFormat = kHTTPDateFormatPostgresT;
        date = [formatter dateFromString:httpDate];
    }
    
    // check for PostgresDateOnly format
    if (date == nil) {
        formatter.dateFormat = kHTTPDateFormatPostgresDateOnly;
        date = [formatter dateFromString:httpDate];
    }
    return date;
}

- (NSString*) httpDateString
{
    return [self rfc1123DateString];
}

- (NSString *)rfc1123DateString
{
    NSDateFormatter *formatter = [NSDate standardDateFormatter];
    formatter.dateFormat = kHTTPDateFormatRFC1123;
    return [formatter stringFromDate:self];
}

- (NSString *)rfc850DateString
{
    NSDateFormatter *formatter = [NSDate standardDateFormatter];
    formatter.dateFormat = kHTTPDateFormatRFC850;
    return [formatter stringFromDate:self];
}

- (NSString *)ansiCDateString
{
    NSDateFormatter *formatter = [NSDate standardDateFormatter];
    formatter.dateFormat = kHTTPDateFormatANSI_C;
    return [formatter stringFromDate:self];
}

- (NSString *)postgresDateString
{
    NSDateFormatter *formatter = [NSDate standardDateFormatter];
    formatter.dateFormat = kHTTPDateFormatPostgresMS;
    return [formatter stringFromDate:self];
}


@end
