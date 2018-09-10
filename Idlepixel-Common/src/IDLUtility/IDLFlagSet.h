//
//  IDLFlagSet.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDLFlagSet : NSObject

-(BOOL)flagForKey:(NSString *)aKey;
-(void)setFlagForKey:(NSString *)aKey;
-(void)clearFlagForKey:(NSString *)aKey;

@end
