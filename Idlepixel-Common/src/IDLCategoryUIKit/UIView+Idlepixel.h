//
//  UIView+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UIView (IDLContainsRect)

-(BOOL)containsRect:(CGRect)aRect;

@end

@interface UIView (IDLEdgeProperties)

@property (assign) CGFloat left;
@property (assign) CGFloat right;
@property (assign) CGFloat top;
@property (assign) CGFloat bottom;

@end

@interface UIView (IDLFindFirstResponder)

+(UIView *)findFirstResponder;

@property (readonly) UIView *findFirstResponder;
@property (readonly) BOOL containsFirstResponder;

@end

@interface UIView (IDLMask)

@property (strong) UIImage *mask;

@end

@interface UIView (IDLIndexPath)

@property (strong) NSIndexPath *indexPath;

@end

@interface UIView (IDLIdentifier)

@property (readonly) NSString *uniqueIdentifier;

@end

@interface UIView (IDLRoundedBorder)

@property (assign) CGFloat cornerRadius;
@property (assign) CGFloat borderWidth;
@property (assign) UIColor *borderColor;
@property (assign) BOOL masksToBounds;

@end

@interface UIView (IDLSubviewBounds)

@property (nonatomic, readonly) CGRect subviewBounds;

@end

@interface UIView (IDLVisible)

@property (readonly) BOOL viewVisible;
@property (readonly) BOOL viewVisibleOnKey;

@end

@interface UIView (IDLSubviews)

-(void)removeAllSubviews;
-(UIView *)subviewWithStringTag:(NSString *)stringTag;
-(UIView *)subviewWithTag:(NSInteger)tag;

@end

@interface UIView (IDLAncestor)

-(BOOL)hasAncestor:(UIView *)view;

@end

@interface UIView (IDLArchiverCopy)

-(id)copyUsingArchiver;

@end

@interface UIView (IDLInitWithBackgroundColor)

+(id)viewWithFrame:(CGRect)rect backgroundColor:(UIColor *)backgroundColor;
-(id)initWithFrame:(CGRect)rect backgroundColor:(UIColor *)backgroundColor;

@end

@interface UIView (IDLShadow)

@property (assign) CGSize shadowOffset;
@property (assign) CGFloat shadowRadius;
@property (assign) CGFloat shadowOpacity;
@property (assign) UIColor *shadowColor;
@property (assign) CGPathRef shadowPath;
@property (assign) BOOL shouldRasterize;

@end
