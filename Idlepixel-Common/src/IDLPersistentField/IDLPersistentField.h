//
//  IDLPersistentField.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLModelObjectProtocols.h"

@interface IDLPersistentField : NSObject <IDLPersistentModelObject>

+(NSString *)stringFromSelector:(SEL)aSelector;
+(SEL)selectorFromString:(NSString *)aSelectorString;

@property (nonatomic, strong) NSString* fieldValue;
@property (nonatomic, strong) NSString* owner;

@property (nonatomic, strong) NSString* setterSelectorString;
@property (nonatomic, assign) SEL setterSelector;

@end
