//
//  UIImageView+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 14/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIImageView+Idlepixel.h"
#import "UIScrollView+Idlepixel.h"

@implementation UIImageView (IDLCrossfade)

- (void)crossfadeToImage:(UIImage *)image withDuration:(NSTimeInterval)interval
{
    if (image == self.image) return;
    
    if (self.image == nil) {
        self.image = image;
    } else {
        UIImage *fromImage = self.image;
        UIImage *toImage = image;
        CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath: @"crossfade"];
        crossFade.duration = interval;
        crossFade.fromValue = (__bridge id) fromImage.CGImage;
        crossFade.toValue = (__bridge id) toImage.CGImage;
        [self.layer addAnimation: crossFade forKey: @"animateContents"];
        self.image = image;
    }
}

@end

@implementation UIImageView (IDLScrollIndicatorsVisible)

- (void) setAlpha:(CGFloat)alpha
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        
        BOOL showIndicator = [(UIScrollView *)[self superview] verticalScrollIndicatorVisible];
        if (showIndicator) {
            if (self.frame.size.width < 10.0f && self.frame.size.height > self.frame.size.width) {
                alpha = 1.0f;
            }
        }
        showIndicator = [(UIScrollView *)[self superview] horizontalScrollIndicatorVisible];
        if (showIndicator) {
            if (self.frame.size.height < 10.0f && self.frame.size.height < self.frame.size.width) {
                alpha = 1.0f;
            }
        }
    }
    [super setAlpha:alpha];
}

@end
