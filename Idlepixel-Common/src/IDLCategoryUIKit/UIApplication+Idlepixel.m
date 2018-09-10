//
//  UIApplication+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIApplication+Idlepixel.h"
#import "UIDevice+Idlepixel.h"
#import "UIWindow+Idlepixel.h"
#import "NSBundle+Idlepixel.h"
#import "NSString+Idlepixel.h"

#define kApplicationSupport @"Application Support"

@implementation UIApplication (IDLDirectories)

- (NSString*) applicationSupportPath
{
    NSString *appSupport = [[self libraryPath] stringByAppendingPathComponent: kApplicationSupport];
    NSFileManager *fileManager = [NSFileManager new];
    if (![fileManager fileExistsAtPath: appSupport]) {
        [fileManager createDirectoryAtPath: appSupport withIntermediateDirectories: NO attributes: nil error: nil];
    }
    return appSupport;
}

- (NSString*) libraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString*) documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end

@implementation UIApplication (IDLIdentifier)

- (NSString *) uniqueDeviceIdentifier
{
    return [[NSBundle mainBundle] uniqueDeviceIdentifier];
}

- (NSString *) uniqueDeviceBundleIdentifier
{
    return [[NSBundle mainBundle] uniqueDeviceBundleIdentifier];
}

- (NSString *) uniqueVersionIdentifier
{
    return [[NSBundle mainBundle] uniqueVersionIdentifier];
}

- (NSString *) uniqueLaunchIdentifier
{
    return [[NSBundle mainBundle] uniqueLaunchIdentifier];
}

@end

@implementation UIApplication (IDLVisible)

-(BOOL)viewVisible:(UIView *)aView
{
    if (aView != nil) {
        return [self rectVisible:aView.frame];
    } else {
        return NO;
    }
}

-(BOOL)rectVisible:(CGRect)aRect
{
    NSArray *windows = self.windows;
    for (UIWindow *window in windows) {
        if ([UIWindow rectVisible:aRect onWindow:window]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)viewVisibleOnKey:(UIView *)aView
{
    if (aView != nil) {
        return [self rectVisibleOnKey:aView.frame];
    } else {
        return NO;
    }
}

-(BOOL)rectVisibleOnKey:(CGRect)aRect
{
    return [UIWindow rectVisible:aRect onWindow:self.keyWindow];
}

@end

@implementation UIApplication (IDLAlertView)

-(BOOL)isAlertVisible
{
    NSArray *windows = self.windows;
    for (UIWindow *window in windows) {
        if (window.isAlertVisible) return YES;
    }
    return NO;
}

-(UIAlertView *)visibleAlertView
{
    UIAlertView *view = nil;
    NSArray *windows = self.windows;
    for (UIWindow *window in windows) {
        view = window.visibleAlertView;
        if (view != nil) return view;
    }
    return nil;
}

-(UIActionSheet *)visibleActionSheet
{
    UIActionSheet *view = nil;
    NSArray *windows = self.windows;
    for (UIWindow *window in windows) {
        view = window.visibleActionSheet;
        if (view != nil) return view;
    }
    return nil;
}

@end
