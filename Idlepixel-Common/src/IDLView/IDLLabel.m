//
//  IDLLabel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLLabel.h"
#import "IDLCGInlineExtensions.h"
#import "UILabel+Idlepixel.h"

@interface IDLLabel ()

@property (nonatomic, assign) CGColorSpaceRef glowColorSpaceRef;
@property (nonatomic, assign) CGColorRef glowColorRef;

@end
 
@implementation IDLLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self configure];
    if (self.shouldLayoutOnAwakeFromNib) {
        [self layoutSubviews];
    }
}

-(BOOL)shouldLayoutOnAwakeFromNib
{
    return NO;
}

-(void)configure
{
    _verticalAlignment = IDLVerticalAlignmentStandard;
    
    self.glowColorSpaceRef = CGColorSpaceCreateDeviceRGB();
    self.glowOffset = CGSizeMake(0.0f, 0.0f);
    self.glowAmount = 0.0f;
    self.glowColor = nil;
}

- (void)setVerticalAlignment:(IDLVerticalAlignment)verticalAlignment
{
    if (_verticalAlignment != verticalAlignment) {
        _verticalAlignment = verticalAlignment;
        [self setNeedsDisplay];
    }
}

- (void)setGlowColor:(UIColor *)glowColor
{
    if (glowColor != _glowColor || self.glowColorRef == nil) {
        _glowColor = glowColor;
        if (self.glowColorRef != nil) {
            CGColorRelease(self.glowColorRef);
            self.glowColorRef = nil;
        }
        if (_glowColor != nil) {
            self.glowColorRef = CGColorCreate(self.glowColorSpaceRef, CGColorGetComponents(_glowColor.CGColor));
        }
    }
}

-(void)setText:(NSString *)text
{
    if (self.kerning != 0.0f && text != nil) {
        [self setText:text withKerning:self.kerning];
    } else {
        [super setText:text];
    }
}

-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    bounds = UIEdgeInsetsInsetRect(bounds, self.insets);
    CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    CGRect result;
    CGFloat originX = 0.0f;
    // calculate horizontal alignment
    switch (self.textAlignment) {
        case NSTextAlignmentLeft:
            originX = bounds.origin.x;
            break;
        case NSTextAlignmentCenter:
            originX = bounds.origin.x + floor((bounds.size.width - rect.size.width)/2.0f);
            break;
        case NSTextAlignmentRight:
            originX = bounds.origin.x + floor(bounds.size.width - rect.size.width);
            break;
            
        default:
            break;
    }
    // calculate vertical alignment
    switch (self.verticalAlignment) {
        case IDLVerticalAlignmentBottom:
            result = CGRectMake(originX, bounds.origin.y + floor(bounds.size.height - rect.size.height), rect.size.width, rect.size.height);
            break;
        case IDLVerticalAlignmentMiddle:
            result = CGRectMake(originX, bounds.origin.y + floor((bounds.size.height - rect.size.height)/2.0f), rect.size.width, rect.size.height);
            break;
        case IDLVerticalAlignmentTop:
            result = CGRectMake(originX, bounds.origin.y, rect.size.width, rect.size.height);
            break;
        default:
            result = bounds;
            break;
    }
    return result;
}

-(void)drawTextInRect:(CGRect)rect
{
    rect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    
    CGContextRef context = NULL;
    
    BOOL customDrawingOccurred = NO;
    
    if (self.glowColor != nil && ![self.glowColor isEqual:[UIColor clearColor]] && self.glowAmount > 0.0f) {
        
        context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        CGContextSetShadowWithColor(context, self.glowOffset, self.glowAmount, self.glowColorRef);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        [super drawTextInRect:rect];
        customDrawingOccurred = YES;
    }
    
    if (self.strokeColor != nil && ![self.strokeColor isEqual:[UIColor clearColor]] && self.strokeWidth > 0.0f) {
        
        if (!customDrawingOccurred) {
            customDrawingOccurred = YES;
            
            context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            [super drawTextInRect:rect];
        } else {
            CGContextSetShadow(context, CGSizeZero, 0.0f);
        }
        
        UIColor *realColor = self.textColor;
        
        self.textColor = self.strokeColor;
        
        CGContextSetLineWidth(context, self.strokeWidth);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        
        [super drawTextInRect:rect];
        
        self.textColor = realColor;
    }
    
    if (!customDrawingOccurred) {
        [super drawTextInRect:rect];
    } else {
        CGContextRestoreGState(context);
    }
}

-(void)dealloc
{
    if (self.glowColorRef != nil) {
        CGColorRelease(self.glowColorRef);
        self.glowColorRef = nil;
    }
    if (self.glowColorSpaceRef != nil) {
        CGColorSpaceRelease(self.glowColorSpaceRef);
        self.glowColorSpaceRef = nil;
    }
}

@end
