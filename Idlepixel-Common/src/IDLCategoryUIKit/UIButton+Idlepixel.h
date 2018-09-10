//
//  UIButton+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (IDLAllStates)

- (void)setTitleForAllStates:(NSString *)title;                     // default is nil. title is assumed to be single line
- (void)setTitleColorForAllStates:(UIColor *)color;                 // default if nil. use opaque white
- (void)setTitleShadowColorForAllStates:(UIColor *)color;           // default is nil. use 50% black
- (void)setImageForAllStates:(UIImage *)image;                      // default is nil. should be same size if different for different states
- (void)setBackgroundImageForAllStates:(UIImage *)image;            // default is nil
- (void)setAttributedTitleForAllStates:(NSAttributedString *)title NS_AVAILABLE_IOS(6_0); // default is nil. title is assumed to be single line

@end
