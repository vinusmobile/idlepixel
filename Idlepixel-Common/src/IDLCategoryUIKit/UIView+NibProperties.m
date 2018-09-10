//
//  UIView+NibProperties.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UIView+NibProperties.h"
#import "NSUserDefaults+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "IDLLoggingMacros.h"

#define kNibPropertiesPrefix @"NibProperties"

NS_INLINE NSString *NibPropertiesKeyPrefix()
{
    return [[NSUserDefaults standardUserDefaults] versionSpecificKey:kNibPropertiesPrefix];
}

NS_INLINE NSString *NibPropertiesKeyForClass(Class viewClass)
{
    if (viewClass == nil) {
        return nil;
    } else {
        return [NSString stringWithFormat:@"%@[%@]",kNibPropertiesPrefix,[viewClass className]];
    }
}

@implementation UIView (NibProperties)

+(NSMutableDictionary *)savedNibProperties
{
    static NSMutableDictionary *properties = nil;
    if (properties == nil) properties = [NSMutableDictionary new];
    return properties;
}


+(void)saveNibPropertiesForNibLoadedView:(UIView *)view
{
    NSString *key = NibPropertiesKeyForClass(view.class);
    IDLNibProperties *properties = [self nibProperties];
    
    if (properties == nil) {
        properties = [IDLNibProperties nibPropertiesForNibLoadedView:view];
        [[self savedNibProperties] setObject:properties forKey:key];
    }
}

-(void)saveNibProperties
{
    [[self class] saveNibPropertiesForNibLoadedView:self];
}

+(IDLNibProperties *)nibProperties
{
    return [[self savedNibProperties] objectForKey:NibPropertiesKeyForClass(self)];
}

-(IDLNibProperties *)nibProperties
{
    return [self.class nibProperties];
}

@end
