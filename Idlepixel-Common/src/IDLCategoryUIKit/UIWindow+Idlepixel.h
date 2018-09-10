//
//  UIWindow+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (IDLVisible)

+(BOOL)viewVisible:(UIView *)aView onWindow:(UIWindow *)aWindow;
+(BOOL)rectVisible:(CGRect)aRect onWindow:(UIWindow *)aWindow;

@end

@interface UIWindow (IDLAlertView)

@property (readonly) BOOL isAlertVisible;
-(UIAlertView *)visibleAlertView;
-(UIActionSheet *)visibleActionSheet;

@end

@interface UIWindow (IDLKeyView)

@property (readonly) UIView *keyView;

@end