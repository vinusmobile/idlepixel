//
//  NSURL+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (IDLUniqueHash)

- (NSString *)uniqueHash;
- (NSString *)uniqueHashWithPathExtension;

@end

@interface NSURL (IDLFilename)

-(NSString *)logFilename;
-(NSString *)logFilenameWithDate:(NSDate *)date suffix:(NSString *)suffix;

@end
