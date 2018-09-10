//
//  UIApplication+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (IDLDirectories)

- (NSString*) applicationSupportPath;
- (NSString*) libraryPath;
- (NSString*) documentsPath;

@end

@interface UIApplication (IDLIdentifier)

- (NSString *) uniqueDeviceIdentifier;
- (NSString *) uniqueDeviceBundleIdentifier;
- (NSString *) uniqueVersionIdentifier;
- (NSString *) uniqueLaunchIdentifier;

@end

@interface UIApplication (IDLVisible)

-(BOOL)viewVisible:(UIView *)aView;
-(BOOL)rectVisible:(CGRect)aRect;

-(BOOL)viewVisibleOnKey:(UIView *)aView;
-(BOOL)rectVisibleOnKey:(CGRect)aRect;

@end

@interface UIApplication (IDLAlertView)

@property (readonly) BOOL isAlertVisible;
@property (readonly) UIAlertView *visibleAlertView;
@property (readonly) UIActionSheet *visibleActionSheet;

@end
