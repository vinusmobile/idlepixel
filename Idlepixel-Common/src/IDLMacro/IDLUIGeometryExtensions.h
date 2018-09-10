//
//  IDLUIGeometryExtensions.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/01/13.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGeometry.h>

#import "IDLCGInlineExtensions.h"

#ifndef Idlepixel_Common_IDLUIGeometryExtensions_h
#define Idlepixel_Common_IDLUIGeometryExtensions_h

UIKIT_STATIC_INLINE UIEdgeInsets UIEdgeInsetsFromRects(CGRect outside, CGRect inside) {
    CGFloat top = CGRectGetMinY(inside)-CGRectGetMinY(outside);
    CGFloat left = CGRectGetMinX(inside)-CGRectGetMinX(outside);
    CGFloat bottom = CGRectGetMaxY(outside)-CGRectGetMaxY(inside);
    CGFloat right = CGRectGetMaxX(outside)-CGRectGetMaxX(inside);
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

#endif
