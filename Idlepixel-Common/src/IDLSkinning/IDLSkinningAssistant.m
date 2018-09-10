//
//  IDLSkinningAssistant.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLSkinningAssistant.h"

@implementation IDLSkinningAssistant

+(NSArray *)availableFontNames
{
    NSArray *familyNames = [UIFont familyNames];
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *familyName in familyNames) {
        [names addObjectsFromArray:[UIFont fontNamesForFamilyName:familyName]];
    }
    
    return [names sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
