//
//  IDLUIKitInlineExtensions.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Idlepixel.h"

#ifndef Idlepixel_Common_IDLUIKitInlineExtensions_h
#define Idlepixel_Common_IDLUIKitInlineExtensions_h

// setters


NS_INLINE void UIViewSetOrigin(UIView *aView, CGPoint origin)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.origin = origin;
        aView.frame = frame;
    }
}

NS_INLINE void UIViewSetSize(UIView *aView, CGSize size)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.size = size;
        aView.frame = frame;
    }
}

NS_INLINE void UIViewSetBorder(UIView *aView, UIColor *color, CGFloat width)
{
    if (aView != nil) {
        aView.borderColor = color;
        aView.borderWidth = width;
    }
}

NS_INLINE void UIViewSetHeight(UIView *aView, CGFloat height)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.size.height = height;
        aView.frame = frame;
    }
}

NS_INLINE void UIViewSetWidth(UIView *aView, CGFloat width)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.size.width = width;
        aView.frame = frame;
    }
}

NS_INLINE void UIViewSetMinY(UIView *aView, CGFloat minY)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.origin.y = minY;
        aView.frame = frame;
    }
}

NS_INLINE void UIViewSetMidY(UIView *aView, CGFloat midY)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.origin.y = midY - CGRectGetHeight(frame) / 2.0f;
        aView.frame = frame;
    }
}

NS_INLINE void UIViewSetMaxY(UIView *aView, CGFloat maxY)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.origin.y = maxY - CGRectGetHeight(frame);
        aView.frame = frame;
    }
}

NS_INLINE void UIViewSetMinX(UIView *aView, CGFloat minX)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.origin.x = minX;
        aView.frame = frame;
    }
}

NS_INLINE void UIViewSetMidX(UIView *aView, CGFloat midX)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.origin.x = midX - CGRectGetWidth(frame) / 2.0f;
        aView.frame = frame;
    }
}


NS_INLINE void UIViewSetMaxX(UIView *aView, CGFloat maxX)
{
    if (aView != nil) {
        CGRect frame = aView.frame;
        frame.origin.x = maxX - CGRectGetWidth(frame);
        aView.frame = frame;
    }
}

// getters

NS_INLINE CGFloat UIViewGetInternalPaddingBottom(UIView *insideView, UIView *outsideView)
{
    CGFloat a = CGRectGetMaxY(insideView.frame);
    CGFloat b = CGRectGetMaxY(outsideView.bounds);
    return (b - a);
}

NS_INLINE CGFloat UIViewGetPaddingVertical(UIView *aView, UIView *anotherView)
{
    CGFloat a = MIN(CGRectGetMaxY(aView.frame),CGRectGetMaxY(anotherView.frame));
    CGFloat b = MAX(CGRectGetMinY(aView.frame),CGRectGetMinY(anotherView.frame));
    return (b - a);
}

NS_INLINE CGFloat UIViewGetPaddingHorizontal(UIView *aView, UIView *anotherView)
{
    CGFloat a = MIN(CGRectGetMaxX(aView.frame),CGRectGetMaxX(anotherView.frame));
    CGFloat b = MAX(CGRectGetMinX(aView.frame),CGRectGetMinX(anotherView.frame));
    return (b - a);
}

#endif
