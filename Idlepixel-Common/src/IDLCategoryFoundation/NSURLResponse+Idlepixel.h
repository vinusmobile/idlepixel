//
//  NSURLResponse+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kURLResponseHTTPHeaderFieldDate;

@interface NSURLResponse (IDLHTTPDate)

-(NSDate *)responseDate;

@end
