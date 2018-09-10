//
//  UIWindow+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIWindow+Idlepixel.h"
#import "UIView+Idlepixel.h"
#import "NSArray+Idlepixel.h"

@implementation UIWindow (IDLVisible)

+(BOOL)viewVisible:(UIView *)aView onWindow:(UIWindow *)aWindow
{
    if (aView == aWindow) {
        return YES;
    } else if (aView != nil && aWindow != nil) {
        return [self rectVisible:aView.frame onWindow:aWindow];
    } else {
        return NO;
    }
}

+(BOOL)rectVisible:(CGRect)aRect onWindow:(UIWindow *)aWindow
{
    if (aWindow != nil) {
        return [aWindow containsRect:aRect];
    } else {
        return NO;
    }
}

@end

@implementation UIWindow (IDLAlertView)

-(BOOL)isAlertVisible
{
    BOOL visible = ([self visibleAlertView] != nil);
    if (!visible) {
        visible = ([self visibleActionSheet] != nil);
    }
    return visible;
}

-(UIAlertView *)visibleAlertView
{
    NSInteger index = [self.subviews indexOfObjectWithKindOfClass:[UIAlertView class]];
    if (index == NSNotFound) {
        return nil;
    } else {
        return [self.subviews objectAtIndex:index];
    }
}

-(UIActionSheet *)visibleActionSheet
{
    NSInteger index = [self.subviews indexOfObjectWithKindOfClass:[UIActionSheet class]];
    if (index == NSNotFound) {
        return nil;
    } else {
        return [self.subviews objectAtIndex:index];
    }
}

@end

@implementation UIWindow (IDLKeyView)

-(UIView *)keyView
{
    return [self.subviews objectAtIndexOrNil:0];
}

@end