//
//  UIScrollView+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/08/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UIScrollView+Idlepixel.h"
#import "IDLMacroHeaders.h"
#import "IDLNSInlineExtensions.h"

@implementation UIScrollView (IDLScrollIndicatorsVisible)

#define kUIScrollViewHorizontalScrollIndicatorVisible       @"UIScrollViewHorizontalScrollIndicatorVisible"
#define kUIScrollViewVerticalScrollIndicatorVisible         @"UIScrollViewVerticalScrollIndicatorVisible"

- (void)setHorizontalScrollIndicatorVisible:(BOOL)horizontalScrollIndicatorVisible
{
    objc_setAssociatedObject(self, kUIScrollViewHorizontalScrollIndicatorVisible, @(horizontalScrollIndicatorVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)horizontalScrollIndicatorVisible
{
    return [objc_getAssociatedObject(self, kUIScrollViewHorizontalScrollIndicatorVisible) boolValue];
}

- (void)setVerticalScrollIndicatorVisible:(BOOL)verticalScrollIndicatorVisible
{
    objc_setAssociatedObject(self, kUIScrollViewVerticalScrollIndicatorVisible, @(verticalScrollIndicatorVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)verticalScrollIndicatorVisible
{
    return [objc_getAssociatedObject(self, kUIScrollViewVerticalScrollIndicatorVisible) boolValue];
}

@end


@implementation UIScrollView (IDLPlatform)

#define kUIScrollViewAssociatedObjectRegisteredClasses        @"UIScrollViewAssociatedObjectRegisteredClasses"

-(BOOL)platformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass registeredFromBundle:(NSBundle *)bundle type:(NSString *)type
{
    BOOL found = NO;
    if (reuseIdentifiableCellClass != nil) {
        BOOL changed = NO;
        NSDictionary *dictionary = objc_getAssociatedObject(self, kUIScrollViewAssociatedObjectRegisteredClasses);
        NSString *reuseClassString = [reuseIdentifiableCellClass className];
        NSString *bundleString = [bundle.pointerKey stringByAppendingFormat:@"-%@",type];
        
        NSString *foundString = [dictionary stringForKey:reuseClassString];
        
        //IDLLogContext(@"%@: %@ (found='%@')",reuseClassString,bundleString,foundString);
        
        if (NSStringEquals(bundleString, foundString)) {
            found = YES;
        } else {
            found = NO;
            changed = YES;
            
            if (dictionary == nil) {
                dictionary = [NSDictionary dictionaryWithObject:bundleString forKey:reuseClassString];
            } else {
                dictionary = [dictionary dictionaryByAddingObject:bundleString forKey:reuseClassString];
            }
        }
        
        if (changed) {
            objc_setAssociatedObject(self, kUIScrollViewAssociatedObjectRegisteredClasses, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return found;
}

@end