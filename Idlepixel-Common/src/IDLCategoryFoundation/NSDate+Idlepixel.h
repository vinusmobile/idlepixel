//
//  NSDate+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kHTTPDateTimeZone;
extern NSString * const kHTTPDateLocale;

extern NSString * const kHTTPDateFormatRFC1123;
extern NSString * const kHTTPDateFormatRFC850;
extern NSString * const kHTTPDateFormatANSI_C;

extern NSString * const kHTTPDateFormatPostgres;
extern NSString * const kHTTPDateFormatPostgresMS;
extern NSString * const kHTTPDateFormatPostgresT;
extern NSString * const kHTTPDateFormatPostgresDateOnly;

@interface NSDate (IDLHTTPDate)

+ (NSDate *)dateWithHTTPDate: (NSString*) httpDate;

+ (NSDate *)dateWithRFC1123Date: (NSString*) httpDate;
+ (NSDate *)dateWithRFC850Date: (NSString*) httpDate;
+ (NSDate *)dateWithANSICDate: (NSString*) httpDate;
+ (NSDate *)dateWithPostgresDate: (NSString*) httpDate;

- (NSString *)httpDateString;

- (NSString *)rfc1123DateString;
- (NSString *)rfc850DateString;
- (NSString *)ansiCDateString;
- (NSString *)postgresDateString;

@end