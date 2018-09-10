//
//  UIButton+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIButton+Idlepixel.h"

@implementation UIButton (IDLAllStates)

- (void)setTitleForAllStates:(NSString *)title
{
    [self setTitle: title forState: UIControlStateNormal];
    [self setTitle: title forState: UIControlStateHighlighted];
    [self setTitle: title forState: UIControlStateSelected];
    [self setTitle: title forState: UIControlStateDisabled];
}

- (void)setTitleColorForAllStates:(UIColor *)color
{
    [self setTitleColor: color forState: UIControlStateNormal];
    [self setTitleColor: color forState: UIControlStateHighlighted];
    [self setTitleColor: color forState: UIControlStateSelected];
    [self setTitleColor: color forState: UIControlStateDisabled];
}

- (void)setTitleShadowColorForAllStates:(UIColor *)color
{
    [self setTitleShadowColor: color forState: UIControlStateNormal];
    [self setTitleShadowColor: color forState: UIControlStateHighlighted];
    [self setTitleShadowColor: color forState: UIControlStateSelected];
    [self setTitleShadowColor: color forState: UIControlStateDisabled];
}

- (void)setImageForAllStates:(UIImage *)image
{
    [self setImage: image forState: UIControlStateNormal];
    [self setImage: image forState: UIControlStateHighlighted];
    [self setImage: image forState: UIControlStateSelected];
    [self setImage: image forState: UIControlStateDisabled];
}

- (void)setBackgroundImageForAllStates:(UIImage *)image
{
    [self setBackgroundImage: image forState: UIControlStateNormal];
    [self setBackgroundImage: image forState: UIControlStateHighlighted];
    [self setBackgroundImage: image forState: UIControlStateSelected];
    [self setBackgroundImage: image forState: UIControlStateDisabled];
}

#ifdef __IPHONE_6_0

- (void)setAttributedTitleForAllStates:(NSAttributedString *)title
{
    [self setAttributedTitle: title forState: UIControlStateNormal];
    [self setAttributedTitle: title forState: UIControlStateHighlighted];
    [self setAttributedTitle: title forState: UIControlStateSelected];
    [self setAttributedTitle: title forState: UIControlStateDisabled];
}

#endif

@end
