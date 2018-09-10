//
//  IDLProgressView.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import "IDLTimerWrapper.h"
#import "IDLCategoryUIKitHeaders.h"
#import "IDLLoggingMacros.h"
#import "IDLCGInlineExtensions.h"

#define kAnimationUpdateInterval    1/60.0f

@interface IDLProgressView () <IDLTimerWrapperDelegate>

@property (nonatomic, strong) IDLTimerWrapper *animationTimer;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *overlayImageView;
@property (nonatomic, strong) UIImageView *progressImageView;

//@property (nonatomic, strong) UIView *mask;

@property (nonatomic, assign, readwrite) CGFloat animationOriginPosition;
@property (nonatomic, assign, readwrite) CGFloat animationTargetPosition;
@property (nonatomic, assign, readwrite) IDLProgressViewAnimation animationType;

-(void)setPosition:(CGFloat)targetPosition limit:(BOOL)limit animated:(BOOL)animated;

@end

@implementation IDLProgressView

-(void)configure
{
    [super configure];
    //self.backgroundColor = [UIColor clearColor];
    //self.opaque = NO;
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame: self.bounds];
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.opaque = NO;
    [self addSubview:self.backgroundImageView];
    
    self.progressImageView = [[UIImageView alloc] initWithFrame: self.bounds];
    self.progressImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.progressImageView.contentMode = UIViewContentModeScaleToFill;
    self.progressImageView.backgroundColor = [UIColor clearColor];
    self.progressImageView.opaque = NO;
    self.progressImageView.hidden = YES;
    [self addSubview:self.progressImageView];
    
    self.overlayImageView = [[UIImageView alloc] initWithFrame: self.bounds];
    self.overlayImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.overlayImageView.contentMode = UIViewContentModeScaleToFill;
    self.overlayImageView.backgroundColor = [UIColor clearColor];
    self.overlayImageView.opaque = NO;
    [self addSubview:self.overlayImageView];
    
    self.cornerRadius = 0.0f;
    self.clipsToBounds = YES;
    self.position = 0.0f;
    self.animationProgressPerSecond = 0.5f;
    self.leadingEdge = IDLProgressViewLeadingEdgeStandard;
    
    self.animationTimer = [IDLTimerWrapper new];
    self.animationTimer.delegate = self;
}

- (void) setCornerRadius:(CGFloat) rad
{
    self.progressImageView.cornerRadius = rad;
    _cornerRadius = rad;
    //self.layer.cornerRadius = cornerRadius;
}

- (void) setBackgroundImage:(UIImage *) anImage
{
    if (anImage != _backgroundImage) {
        _backgroundImage = anImage;
        self.backgroundImageView.image = anImage;
        [self setNeedsLayout];
    }
}

- (void) setOverlayImage:(UIImage *) anImage
{
    if (anImage != _overlayImage) {
        _overlayImage = anImage;
        self.overlayImageView.image = anImage;
        [self setNeedsLayout];
    }
}

- (void) setProgressImage:(UIImage *) anImage
{
    if (anImage != _progressImage) {
        _progressImage = anImage;
        self.progressImageView.image = anImage;
        [self setNeedsLayout];
    }
}

-(void)setProgressEdgeInsets:(UIEdgeInsets)progressEdgeInsets
{
    _progressEdgeInsets = progressEdgeInsets;
    [self setNeedsLayout];
}

-(void)setLeadingEdge:(IDLProgressViewLeadingEdge)leadingEdge
{
    _leadingEdge = leadingEdge;
    [self setNeedsLayout];
}

#define kAnimationProgressPerSecondMin 0.01f
#define kAnimationProgressPerSecondMax 10.0f

-(void)setAnimationProgressPerSecond:(CGFloat)animationProgressPerSecond
{
    _animationProgressPerSecond = MAX(kAnimationProgressPerSecondMin,
                                      MIN(kAnimationProgressPerSecondMax,
                                          animationProgressPerSecond));
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundImageView.frame = self.bounds;
    self.overlayImageView.frame = self.bounds;
    
    // figure out bar size
    if (self.position <= 0.0f) {
        self.progressImageView.hidden = YES;
    } else {
        self.progressImageView.hidden = NO;
        CGRect progressRect = UIEdgeInsetsInsetRect(self.bounds, self.progressEdgeInsets);
        CGFloat progressScalar, progressScalarRemainder;
        //
        if (self.leadingEdge == IDLProgressViewLeadingEdgeLeft || self.leadingEdge == IDLProgressViewLeadingEdgeRight) {
            progressScalar = progressRect.size.width;
        } else {
            progressScalar = progressRect.size.height;
        }
        //
        progressScalarRemainder = progressScalar;
        progressScalar = progressScalar * MIN(1.0f, self.position);
        progressScalarRemainder -= progressScalar;
        //
        if (self.leadingEdge == IDLProgressViewLeadingEdgeLeft) {
            progressRect.size.width = progressScalar;
        } else if (self.leadingEdge == IDLProgressViewLeadingEdgeRight) {
            progressRect.origin.x = progressRect.origin.x+progressScalarRemainder;
            progressRect.size.width = progressScalar;
        } else if (self.leadingEdge == IDLProgressViewLeadingEdgeTop) {
            progressRect.size.height = progressScalar;
        } else if (self.leadingEdge == IDLProgressViewLeadingEdgeBottom) {
            progressRect.origin.y = progressRect.origin.y+progressScalarRemainder;
            progressRect.size.height = progressScalar;
        }
        //
        self.progressImageView.frame = progressRect;
    }
}

#pragma mark TimerWrapper delegate

-(void)timerWrapperFired:(IDLTimerWrapper *)wrapper
{
    if (self.animationType != IDLProgressViewAnimationNone && _position != _animationTargetPosition) {
        CGFloat increment = kAnimationUpdateInterval*self.animationProgressPerSecond;
        if (_position > _animationTargetPosition) {
            increment = -increment;
        }
        CGFloat newPosition = _animationTargetPosition;
        if (_position < _animationTargetPosition) {
            newPosition = MIN(_animationTargetPosition, _position+increment);
        } else if (_position > _animationTargetPosition) {
            newPosition = MAX(_animationTargetPosition, _position+increment);
        }
        if (self.animationType == IDLProgressViewAnimationLimit) {
            CGFloat normalizedPosition = (newPosition-_animationOriginPosition)/(_animationTargetPosition-_animationOriginPosition);
            if (normalizedPosition > 0.0f) {
                normalizedPosition = sqrt(normalizedPosition);
            }
            CGFloat logCurve = fabs(log(normalizedPosition));
            if (logCurve < 1.0f) {
                newPosition = _position+logCurve*increment;
            }
            //IDLLogContext(@"oh boy: %f => %f => %f",self.animationOriginPosition,self.position,self.animationTargetPosition);
        }
        _position = newPosition;
        
        if (_position == _animationTargetPosition) {
            if ([self.delegate respondsToSelector:@selector(progressViewAnimationCompleted:)]) {
                [self.delegate progressViewAnimationCompleted:self];
            }
        }
        
    }
    
    if (self.animationType == IDLProgressViewAnimationNone || _position == _animationTargetPosition) {
        [self.animationTimer stop];
        _position = _animationTargetPosition;
        _animationOriginPosition = _animationTargetPosition;
    }
    [self setNeedsLayout];
}

#pragma mark Private Position Setter

-(void)setPosition:(CGFloat)targetPosition limit:(BOOL)limit animated:(BOOL)animated
{
    // stop the timer - we will restart it if required
    [self.animationTimer stop];
    //
    if (targetPosition < 0.0f) {
        targetPosition = 0.0f;
    } else if (targetPosition > 1.0f) {
        targetPosition = 1.0f;
    }
    self.animationOriginPosition = _position;
    self.animationTargetPosition = targetPosition;
    
    if (_position == targetPosition) {
        limit = NO;
        animated = NO;
    }
    
    if (limit) {
        animated = YES;
        self.animationType = IDLProgressViewAnimationLimit;
    } else if (animated) {
        self.animationType = IDLProgressViewAnimationNormal;
    } else {
        self.animationType = IDLProgressViewAnimationNone;
        _position = targetPosition;
        
    }
    if (animated) {
        self.animationTimer.interval = kAnimationUpdateInterval;
        [self.animationTimer start];
    } else {
        [self setNeedsLayout];
    }
}

#pragma mark Public Position Setters

CG_INLINE CGFloat FractionToPosition(NSUInteger numerator, NSUInteger denominator)
{
    if (denominator == 0) {
        return 0.0f;
    } else {
        return MAX(0.0f, MIN(1.0f, ((CGFloat)numerator/(CGFloat)denominator)));
    }
}

-(void)setPosition:(CGFloat)position
{
    [self setPosition:position limit:NO animated:NO];
}

-(void)setPosition:(CGFloat)position animated:(BOOL)animated
{
    [self setPosition:position limit:NO animated:animated];
}

-(void)setFractionalPosition:(NSUInteger)numerator denominator:(NSUInteger)denominator animated:(BOOL)animated
{
    [self setPosition:FractionToPosition(numerator, denominator) limit:NO animated:animated];
}

-(void)setPositionLimit:(CGFloat)limit
{
    [self setPosition:limit limit:YES animated:YES];
}

-(void)setFractionalPositionLimit:(NSUInteger)numerator denominator:(NSUInteger)denominator
{
    [self setPosition:FractionToPosition(numerator, denominator) limit:YES animated:YES];
}


@end
