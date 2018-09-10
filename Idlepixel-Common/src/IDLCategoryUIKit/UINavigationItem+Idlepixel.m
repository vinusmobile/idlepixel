//
//  UINavigationItem+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 25/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UINavigationItem+Idlepixel.h"

@implementation UINavigationItem (IDLSubtitle)

#define kUINavigationBarAssociatedObjectSubtitle      @"UINavigationBarAssociatedObjectSubtitle"

- (void)setSubtitle:(NSString *)subtitle
{
    if (![subtitle isKindOfClass:[NSString class]]) {
        subtitle = nil;
    }
    objc_setAssociatedObject(self, kUINavigationBarAssociatedObjectSubtitle, subtitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)subtitle
{
    return objc_getAssociatedObject(self, kUINavigationBarAssociatedObjectSubtitle);
}

@end

@implementation UINavigationItem (IDLNavigationItems)

+(NSArray *)navigationItemsForViewControllers:(NSArray *)viewControllers
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:viewControllers.count];
    
    UINavigationItem *item = nil;
    
    for (UIViewController *vc in viewControllers) {
        if (CLASS_OR_NIL(vc, UIViewController)) {
            item = vc.navigationItem;
            if (item) [items addObject:item];
        }
    }
    
    return [NSArray arrayWithArray:items];
}

@end
