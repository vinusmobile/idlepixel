//
//  UINavigationItem+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 25/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (IDLSubtitle)

@property (readwrite) NSString *subtitle;

@end

@interface UINavigationItem (IDLNavigationItems)

+(NSArray *)navigationItemsForViewControllers:(NSArray *)viewControllers;

@end
