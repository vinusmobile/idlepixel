//
//  IDLProgressView.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLTypedefs.h"
#import "IDLView.h"

@class IDLProgressView;

@protocol IDLProgressViewDelegate <NSObject>

@required
-(void)progressViewAnimationCompleted:(IDLProgressView *)progressView;

@end

@interface IDLProgressView : IDLView <IDLConfigurable>

@property (nonatomic, assign) CGFloat position;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIEdgeInsets progressEdgeInsets;
@property (nonatomic, assign) IDLProgressViewLeadingEdge leadingEdge;

@property (nonatomic, assign) CGFloat animationProgressPerSecond;

@property (nonatomic, assign, readonly) CGFloat animationTargetPosition;
@property (nonatomic, assign, readonly) IDLProgressViewAnimation animationType;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *overlayImage;
@property (nonatomic, strong) UIImage *progressImage;
//@property (nonatomic, strong) UIImage *maskImage;

@property (nonatomic, weak) id<IDLProgressViewDelegate> delegate;

-(void)setPosition:(CGFloat)position animated:(BOOL)animated;
-(void)setFractionalPosition:(NSUInteger)numerator denominator:(NSUInteger)denominator animated:(BOOL)animated;

-(void)setPositionLimit:(CGFloat)limit;
-(void)setFractionalPositionLimit:(NSUInteger)numeratorLimit denominator:(NSUInteger)denominator;

@end
