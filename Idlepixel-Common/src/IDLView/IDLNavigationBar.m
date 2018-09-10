//
//  IDLNavigationBar.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 20/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLNavigationBar.h"
#import "UIView+Idlepixel.h"
#import "NSArray+Idlepixel.h"

#import "IDLTapGestureRecognizer.h"

NSString * const kIDLNavigationBarMultiTapReceivedNotification = @"IDLNavigationBarMultiTapReceivedNotification";

@interface IDLNavigationBar ()

@property (nonatomic, strong) UIView *customContentContainer;

@property (nonatomic, strong, readwrite) UIView *backgroundContainer;
@property (nonatomic, strong, readwrite) UIView *leftBarViewsContainer;
@property (nonatomic, strong, readwrite) UIView *rightBarViewsContainer;
@property (nonatomic, strong, readwrite) UIView *leftAlignedOverlayContainer;
@property (nonatomic, strong, readwrite) UIView *rightAlignedOverlayContainer;

@property (nonatomic, strong, readwrite) UIView *centeredViewContainer;

@property (nonatomic, strong) IDLActionTargetSet *actionTargetSet;

@property (nonatomic, strong) IDLTapGestureRecognizer *multiTapNotificationRecognizer;

@end

@implementation IDLNavigationBar

static CGFloat preferredBarHeight = 44.0f;

+(void)setPreferredBarHeight:(CGFloat)barHeight
{
    preferredBarHeight = barHeight;
}

+(CGFloat)preferredBarHeight
{
    return preferredBarHeight;
}

-(id)init
{
    self = [super init];
    if (self) [self configure];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self configure];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self configure];
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
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
    self.barHeight = [[self class] preferredBarHeight];
    self.actionTargetSet = [IDLActionTargetSet new];
    
    self.multiTapNotificationTapsRequired = 5;
    self.multiTapNotificationTouchesRequired = 1;
}

-(CGSize)squareButtonSize
{
    return CGSizeMake(self.barHeight, self.barHeight);
}

-(void)refreshContainerViews
{
    CGRect containerBounds = self.bounds;
    
    if (self.customContentContainer == nil) {
        self.customContentContainer = [[UIView alloc] initWithFrame:containerBounds];
        self.customContentContainer.backgroundColor = [UIColor clearColor];
        self.customContentContainer.contentMode = UIViewContentModeRedraw;
        self.customContentContainer.autoresizesSubviews = NO;
    }
    
    if (self.backgroundContainer == nil) {
        self.backgroundContainer = [[UIView alloc] initWithFrame:containerBounds];
        self.backgroundContainer.backgroundColor = [UIColor clearColor];
        self.backgroundContainer.contentMode = UIViewContentModeRedraw;
    }
    
    if (self.leftBarViewsContainer == nil) {
        self.leftBarViewsContainer = [[UIView alloc] initWithFrame:containerBounds];
        self.leftBarViewsContainer.backgroundColor = [UIColor clearColor];
        self.leftBarViewsContainer.contentMode = UIViewContentModeLeft;
        self.leftBarViewsContainer.autoresizesSubviews = NO;
    }
    if (self.rightBarViewsContainer == nil) {
        self.rightBarViewsContainer = [[UIView alloc] initWithFrame:containerBounds];
        self.rightBarViewsContainer.backgroundColor = [UIColor clearColor];
        self.rightBarViewsContainer.contentMode = UIViewContentModeRight;
        self.rightBarViewsContainer.autoresizesSubviews = NO;
    }
    if (self.centeredViewContainer == nil) {
        self.centeredViewContainer = [[UIView alloc] initWithFrame:containerBounds];
        self.centeredViewContainer.backgroundColor = [UIColor clearColor];
        self.centeredViewContainer.contentMode = UIViewContentModeCenter;
        self.centeredViewContainer.autoresizesSubviews = NO;
        self.centeredViewContainer.userInteractionEnabled = NO;
    }
    
    if (self.leftAlignedOverlayContainer == nil) {
        self.leftAlignedOverlayContainer = [[UIView alloc] initWithFrame:containerBounds];
        self.leftAlignedOverlayContainer.backgroundColor = [UIColor clearColor];
        self.leftAlignedOverlayContainer.contentMode = UIViewContentModeLeft;
        self.leftAlignedOverlayContainer.userInteractionEnabled = NO;
        self.leftAlignedOverlayContainer.autoresizesSubviews = NO;
    }
    if (self.rightAlignedOverlayContainer == nil) {
        self.rightAlignedOverlayContainer = [[UIView alloc] initWithFrame:containerBounds];
        self.rightAlignedOverlayContainer.backgroundColor = [UIColor clearColor];
        self.rightAlignedOverlayContainer.contentMode = UIViewContentModeRight;
        self.rightAlignedOverlayContainer.userInteractionEnabled = NO;
        self.rightAlignedOverlayContainer.autoresizesSubviews = NO;
    }
    
    self.customContentContainer.frame = containerBounds;
    self.backgroundContainer.frame = containerBounds;
    self.customBackgroundView.frame = containerBounds;
    self.flairBackgroundView.frame = containerBounds;
    
    [self.customContentContainer addSubview:self.backgroundContainer];
    [self.customContentContainer addSubview:self.leftBarViewsContainer];
    [self.customContentContainer addSubview:self.rightBarViewsContainer];
    [self.customContentContainer addSubview:self.centeredViewContainer];
    [self.customContentContainer addSubview:self.leftAlignedOverlayContainer];
    [self.customContentContainer addSubview:self.rightAlignedOverlayContainer];
    
    [self addSubview:self.customContentContainer];
}

-(void)setCustomBackgroundView:(UIView *)customBackgroundView
{
    if (customBackgroundView != _customBackgroundView) {
        if (_customBackgroundView) {
            [_customBackgroundView removeFromSuperview];
        }
        _customBackgroundView = customBackgroundView;
        if (customBackgroundView != nil) {
            [self.backgroundContainer insertSubview:_customBackgroundView atIndex:0];
        }
    }
    [self refreshContainerViews];
}

-(void)setFlairBackgroundView:(UIView *)flairBackgroundView
{
    if (flairBackgroundView != _flairBackgroundView) {
        if (_flairBackgroundView) {
            [_flairBackgroundView removeFromSuperview];
        }
        _flairBackgroundView = flairBackgroundView;
        if (flairBackgroundView != nil) {
            if (self.customBackgroundView != nil) {
                [self.backgroundContainer insertSubview:_flairBackgroundView aboveSubview:self.customBackgroundView];
            } else {
                [self.backgroundContainer addSubview:_flairBackgroundView];
            }
        }
    }
    [self refreshContainerViews];
}

-(void)setLeftAlignedOverlayView:(UIView *)leftAlignedOverlayView
{
    if (leftAlignedOverlayView != _leftAlignedOverlayView) {
        if (_leftAlignedOverlayView) {
            [_leftAlignedOverlayView removeFromSuperview];
        }
        _leftAlignedOverlayView = leftAlignedOverlayView;
        if (leftAlignedOverlayView != nil) {
            [self.leftAlignedOverlayContainer insertSubview:_leftAlignedOverlayView atIndex:0];
        }
    }
    [self refreshContainerViews];
}

-(void)setRightAlignedOverlayView:(UIView *)rightAlignedOverlayView
{
    if (rightAlignedOverlayView != _rightAlignedOverlayView) {
        if (_rightAlignedOverlayView) {
            [_rightAlignedOverlayView removeFromSuperview];
        }
        _rightAlignedOverlayView = rightAlignedOverlayView;
        if (rightAlignedOverlayView != nil) {
            [self.rightAlignedOverlayContainer insertSubview:_rightAlignedOverlayView atIndex:0];
        }
    }
    [self refreshContainerViews];
}

-(void)addActionToButton:(UIButton *)button
{
    [button removeTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setLeftBarViews:(NSArray *)leftBarViews
{
    if (leftBarViews != _leftBarViews) {
        [self refreshContainerViews];
        [self.leftBarViewsContainer removeAllSubviews];
        _leftBarViews = leftBarViews;
        for (UIView *view in _leftBarViews) {
            if ([view isKindOfClass:[UIButton class]]) [self addActionToButton:(UIButton *)view];
            [self.leftBarViewsContainer addSubview:view];
        }
        [self alignLeftBarViews];
    }
}

-(void)setRightBarViews:(NSArray *)rightBarViews
{
    if (rightBarViews != _rightBarViews) {
        [self refreshContainerViews];
        [self.rightBarViewsContainer removeAllSubviews];
        _rightBarViews = rightBarViews;
        for (UIView *view in _rightBarViews) {
            if ([view isKindOfClass:[UIButton class]]) [self addActionToButton:(UIButton *)view];
            [self.rightBarViewsContainer addSubview:view];
        }
        [self alignRightBarViews];
    }
}

-(void)alignLeftBarViews
{
    CGFloat offset = 0.0f;
    CGRect frame = CGRectZero;
    
    for (UIView *view in self.leftBarViews) {
        frame = view.frame;
        frame.origin.x = offset;
        view.frame = frame;
        offset = CGRectGetMaxX(frame);
    }
    self.leftBarViewsContainer.frame = CGRectMake(0.0f, 0.0f, offset, self.frame.size.height);
    
    if (self.leftAlignedOverlayView != nil) {
        frame = self.leftAlignedOverlayView.frame;
        frame.origin.x = 0.0f;
        self.leftAlignedOverlayView.frame = frame;
    }
}

-(void)alignRightBarViews
{
    CGFloat offset = 0.0f;
    CGRect frame = CGRectZero;
    
    NSArray *reversedArray = self.rightBarViews.reversedArray;
    
    for (UIView *view in reversedArray) {
        frame = view.frame;
        frame.origin.x = offset;
        view.frame = frame;
        offset = CGRectGetMaxX(frame);
    }
    CGSize frameSize = self.frame.size;
    self.rightBarViewsContainer.frame = CGRectMake(frameSize.width-offset, 0.0f, offset, frameSize.height);
    
    if (self.rightAlignedOverlayView != nil) {
        frame = self.rightAlignedOverlayView.frame;
        frame = CGRectMake(frameSize.width - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
        self.rightAlignedOverlayView.frame = frame;
    }
}

-(void)setBarHeight:(CGFloat)barHeight
{
    if (barHeight != _barHeight) {
        _barHeight = barHeight;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self refreshContainerViews];
    [self alignRightBarViews];
    [self alignLeftBarViews];
    
    if (self.multiTapNotificationEnabled) {
        if (self.multiTapNotificationRecognizer == nil) {
            IDLTapGestureRecognizer *tap = [[IDLTapGestureRecognizer alloc] initWithTarget:self action:@selector(multiTapNotificationRecognizerAction:)];
            tap.canBePreventedByGestureRecognizers = YES;
            tap.preventsGestureRecognizers = NO;
            self.multiTapNotificationRecognizer = tap;
        }
        
        [self removeGestureRecognizer:self.multiTapNotificationRecognizer];
        [self addGestureRecognizer:self.multiTapNotificationRecognizer];
        
        self.multiTapNotificationRecognizer.numberOfTapsRequired = self.multiTapNotificationTapsRequired;
        self.multiTapNotificationRecognizer.numberOfTouchesRequired = self.multiTapNotificationTouchesRequired;
        
    } else if (self.multiTapNotificationRecognizer != nil) {
        [self removeGestureRecognizer:self.multiTapNotificationRecognizer];
        self.multiTapNotificationRecognizer = nil;
    }
    
}

-(void)multiTapNotificationRecognizerAction:(UIGestureRecognizer *)recognizer
{
    if (self.multiTapNotificationEnabled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kIDLNavigationBarMultiTapReceivedNotification object:nil];
    }
}

-(void)buttonAction:(id)sender
{
    [self.actionTargetSet sendActionsForControlEvents:UIControlEventTouchUpInside sender:sender];
    
    if ([self.leftBarViews containsObject:sender]) {
        if ([self.buttonDelegate respondsToSelector:@selector(navigationBar:leftButtonTappedWithIndex:)]) {
            NSInteger leftButtonIndex = [self.leftBarViews indexOfObject:sender];
            [self.buttonDelegate navigationBar:self leftButtonTappedWithIndex:leftButtonIndex];
        }
    }
    
    if ([self.rightBarViews containsObject:sender]) {
        if ([self.buttonDelegate respondsToSelector:@selector(navigationBar:rightButtonTappedWithIndex:)]) {
            NSInteger rightButtonIndex = [self.rightBarViews indexOfObject:sender];
            [self.buttonDelegate navigationBar:self rightButtonTappedWithIndex:rightButtonIndex];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize superSize = [super sizeThatFits:size];
    [self setTitleVerticalPositionAdjustment:-7 forBarMetrics:UIBarMetricsDefault];
    superSize.height = self.barHeight;
    return superSize;
}

#pragma mark IDLActionTarget

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.actionTargetSet addTarget:target action:action forControlEvents:controlEvents];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.actionTargetSet removeTarget:target action:action forControlEvents:controlEvents];
}

- (void)removeTarget:(id)target
{
    [self.actionTargetSet removeTarget:target];
}


@end
