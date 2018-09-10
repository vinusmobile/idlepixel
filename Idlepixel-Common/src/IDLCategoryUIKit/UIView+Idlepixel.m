//
//  UIView+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIView+Idlepixel.h"
#import "IDLCGInlineExtensions.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIApplication+Idlepixel.h"
#import "IDLNSInlineExtensions.h"
#import "NSObject+Idlepixel.h"
#import "NSString+Idlepixel.h"

@implementation UIView (IDLContainsRect)

-(BOOL)containsRect:(CGRect)aRect
{
    return CGRectContainsRect(self.frame, aRect);
}

@end

@implementation UIView (IDLEdgeProperties)

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setLeft:(CGFloat) aLeft
{
    self.frame = CGRectSetX(self.frame, aLeft);
}

- (void) setRight:(CGFloat) aRight
{
    self.frame = CGRectSetX(self.frame, aRight - self.frame.size.width);
}

- (void) setTop:(CGFloat) aTop
{
    self.frame = CGRectSetY(self.frame, aTop);
}

- (void) setBottom:(CGFloat) aBottom
{
    self.frame = CGRectSetY(self.frame, aBottom - self.frame.origin.y);
}

@end

@implementation UIView (IDLFindFirstResponder)

+(UIView *)findFirstResponder
{
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	return [keyWindow findFirstResponder];
}

-(UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
	
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
		
        if (firstResponder != nil) {
			return firstResponder;
        }
    }
	
    return nil;
}

-(BOOL)containsFirstResponder
{
	return [self findFirstResponder] != nil;
}

@end

static char* const kUIViewMaskAssociatedObjectKey = "UIView+Mask_Mask";

@implementation UIView (IDLMask)

- (UIImage*) mask
{
    if (self.layer.mask == nil) {
        return nil;
    } else {
        return objc_getAssociatedObject(self, kUIViewMaskAssociatedObjectKey);
    }
}

- (void) setMask:(UIImage *)mask
{
    if (mask == nil) {
        self.layer.mask = nil;
    } else {
        CALayer *maskLayer = [CALayer layer];
        [maskLayer setFrame: CGRectMake(0, 0, [mask size].width * [mask scale], [mask size].height * [mask scale])];
        [maskLayer setContents: (id) [mask CGImage]];
        self.layer.mask = maskLayer;
    }
    
    objc_setAssociatedObject(self, kUIViewMaskAssociatedObjectKey, mask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

static char* const kUIViewIndexPathAssociatedObjectKey = "UIView+NSIndexPath_IndexPath";

@implementation UIView (IDLIndexPath)

- (NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, kUIViewIndexPathAssociatedObjectKey);
}

- (void) setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, kUIViewIndexPathAssociatedObjectKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

static char* const kUIViewUniqueIdentifierAssociatedObjectKey = "UIView+NSString_UniqueIdentifier";

@implementation UIView (IDLIdentifier)

- (NSString *)uniqueIdentifier
{
    NSString *identifier = objc_getAssociatedObject(self, kUIViewUniqueIdentifierAssociatedObjectKey);
    if (!identifier) {
        identifier = [NSString universalUniqueID];
        objc_setAssociatedObject(self, kUIViewUniqueIdentifierAssociatedObjectKey, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return identifier;
}

@end

@implementation UIView (IDLRoundedBorder)

- (void)setCornerRadius:(CGFloat)radius
{
	CALayer *layer = self.layer;
	[layer setCornerRadius:radius];
	if (radius == 0.0)
		[layer setMasksToBounds:NO];
	else
		[layer setMasksToBounds:YES];
}

- (CGFloat)cornerRadius
{
	return [self.layer cornerRadius];
}

- (void)setBorderWidth:(CGFloat)width
{
	[self.layer setBorderWidth:width];
}

- (CGFloat)borderWidth
{
	return [self.layer borderWidth];
}

- (void)setBorderColor:(UIColor *)color
{
	[self.layer setBorderColor:[color CGColor]];
}

- (UIColor *)borderColor
{
	return [UIColor colorWithCGColor:[self.layer borderColor]];
}

- (BOOL) masksToBounds
{
	return [self.layer masksToBounds];
}

- (void) setMasksToBounds: (BOOL) toMask
{
	[self.layer setMasksToBounds: toMask];
}

@end

@implementation UIView (IDLSubviewBounds)

-(CGRect)subviewBounds
{
    CGRect bounds = self.bounds;
    NSArray *subviews = self.subviews;
    if ([subviews count] > 0) {
        UIView *subview = nil;
        CGRect subBounds;
        for (subview in subviews) {
            subBounds = [self convertRect:[subview subviewBounds] fromView:subview];
            if (subBounds.size.width != 0.0f && subBounds.size.height != 0.0f) {
                bounds = CGRectUnion(bounds, subBounds);
            }
        }
        
    }
    return bounds;
}

@end

@implementation UIView (IDLVisible)

-(BOOL)viewVisible
{
    return [[UIApplication sharedApplication] viewVisible:self];
}

-(BOOL)viewVisibleOnKey
{
    return [[UIApplication sharedApplication] viewVisibleOnKey:self];
}

@end

@implementation UIView (IDLSubviews)

-(void)removeAllSubviews
{
    NSArray *subviews = [self.subviews copy];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
}

-(UIView *)subviewWithStringTag:(NSString *)stringTag
{
    NSArray *subviews = [self.subviews copy];
    for (UIView *view in subviews) {
        if (NSStringEquals(view.stringTag, stringTag)) {
            return view;
        }
    }
    return nil;
}

-(UIView *)subviewWithTag:(NSInteger)tag
{
    NSArray *subviews = [self.subviews copy];
    for (UIView *view in subviews) {
        if (view.tag == tag) {
            return view;
        }
    }
    return nil;
}

@end

@implementation UIView (IDLAncestor)

-(BOOL)hasAncestor:(UIView *)view
{
    if (view == nil) {
        return NO;
    } else if (view == self) {
        return YES;
    } else {
        UIView *superview = self.superview;
        while (superview != nil) {
            if (view == superview) {
                return YES;
            } else {
                superview = superview.superview;
            }
        }
        return NO;
    }
}

@end

@implementation UIView (IDLArchiverCopy)

-(id)copyUsingArchiver
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end

@implementation UIView (IDLInitWithBackgroundColor)

+(id)viewWithFrame:(CGRect)rect backgroundColor:(UIColor *)backgroundColor
{
    return [[self alloc] initWithFrame:rect backgroundColor:backgroundColor];
}

-(id)initWithFrame:(CGRect)rect backgroundColor:(UIColor *)backgroundColor
{
    self = [self initWithFrame:rect];
    if (self) {
        self.backgroundColor = backgroundColor;
    }
    return self;
}

@end

@implementation UIView (IDLShadow)

-(CGSize)shadowOffset
{
    if ([self isKindOfClass:[UILabel class]]) {
        return [(UILabel *)self shadowOffset];
    } else {
        return self.layer.shadowOffset;
    }
}

-(void)setShadowOffset:(CGSize)shadowOffset
{
    if ([self isKindOfClass:[UILabel class]]) {
        [(UILabel *)self setShadowOffset:shadowOffset];
    }
    self.layer.shadowOffset = shadowOffset;
}

-(CGFloat)shadowRadius
{
    return self.layer.shadowRadius;
}

-(void)setShadowRadius:(CGFloat)shadowRadius
{
    self.layer.shadowRadius = shadowRadius;
}

-(CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}

-(UIColor *)shadowColor
{
    if ([self isKindOfClass:[UILabel class]]) {
        return [(UILabel *)self shadowColor];
    } else {
        CGColorRef shadowColorRef = self.layer.shadowColor;
        if (shadowColorRef != nil) {
            return [UIColor colorWithCGColor:shadowColorRef];
        } else {
            return nil;
        }
    }
}

-(void)setShadowColor:(UIColor *)shadowColor
{
    if ([self isKindOfClass:[UILabel class]]) {
        [(UILabel *)self setShadowColor:shadowColor];
    } else {
        if (shadowColor != nil) {
            self.layer.shadowColor = shadowColor.CGColor;
        } else {
            self.layer.shadowColor = nil;
        }
    }
}

-(CGPathRef)shadowPath
{
    return self.layer.shadowPath;
}

-(void)setShadowPath:(CGPathRef)shadowPath
{
    self.layer.shadowPath = shadowPath;
}

-(BOOL)shouldRasterize
{
    return self.layer.shouldRasterize;
}

-(void)setShouldRasterize:(BOOL)shouldRasterize
{
    self.layer.shouldRasterize = shouldRasterize;
}

@end

