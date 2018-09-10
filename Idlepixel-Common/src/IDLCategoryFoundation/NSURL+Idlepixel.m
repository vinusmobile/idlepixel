//
//  NSURL+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSURL+Idlepixel.h"
#import "NSString+Idlepixel.h"
#import "NSArray+Idlepixel.h"

@implementation NSURL (IDLUniqueHash)

- (NSString *)uniqueHash
{
    return [[NSString stringWithFormat:@"%@%@?%@",self.host,self.path,self.query] md5Hash];
}

- (NSString *)uniqueHashWithPathExtension
{
    NSString *hash = self.uniqueHash;
    if (self.pathExtension != nil) {
        hash = [hash stringByAppendingPathExtension:self.pathExtension];
    }
    return hash;
}


@end

@implementation NSURL (IDLFilename)

-(NSString *)logFilename
{
    return [self logFilenameWithDate:nil suffix:nil];
}

-(NSString *)logFilenameWithDate:(NSDate *)date suffix:(NSString *)suffix
{
    NSString *filename = nil;
    
    if (date != nil) {
        filename = [NSString stringWithFormat:@"%@ ",[NSString filenameDateStringFromDate:date]];
    } else {
        filename = @"";
    }
    
    NSArray *components = [self.pathComponents arrayByRemovingObject:@"/"];
    
    if (components.count == 0) {
        components = @[self.host];
    }
    
    filename = [filename stringByAppendingFormat:@"%@",[components componentsJoinedByString:@" | "]];
    filename = [filename stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
    filename = [filename stringByReplacingOccurrencesOfString: @"\\" withString: @"_"];
    if (suffix != nil) {
        filename = [filename stringByAppendingFormat:@" %@",suffix];
    }
    return filename;
}

@end