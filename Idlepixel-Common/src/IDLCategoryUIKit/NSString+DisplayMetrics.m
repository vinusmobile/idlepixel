//
//  NSString+DisplayMetrics.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSString+DisplayMetrics.h"
#import "NSString+Idlepixel.h"

@implementation NSString (IDLDisplayMetrics)

- (CGFloat)multilineHeightWithFont:(UIFont *)font forWidth:(CGFloat)width
{
    return [self multilineHeightWithFont:font forWidth:width lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGFloat)multilineHeightWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    return size.height;
}

@end
