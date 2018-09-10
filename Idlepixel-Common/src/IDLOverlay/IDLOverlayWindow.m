//
//  IDLOverlayWindow.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/12/2013.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLOverlayWindow.h"
#import "IDLAbstractSharedSingleton.h"

#import "IDLUIKitInlineExtensions.h"

@interface IDLOverlayWindow ()

@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, assign) BOOL reallyHidden;

@property (nonatomic, weak) UIView *backgroundView;

@end

#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kScreenHeight               [UIScreen mainScreen].bounds.size.height

#define kAppearAnimationDuration    0.5f

@implementation IDLOverlayWindow

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    __strong static IDLOverlayWindow *sharedOverlay = nil;
    
    dispatch_once(&pred, ^{
        sharedOverlay = [[IDLOverlayWindow alloc] init];
    });
    
    return sharedOverlay;
}

+ (instancetype)sharedOverlay
{
    return [self sharedInstance];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        self.windowLevel = UIWindowLevelStatusBar+1.f;
        self.frame = frame;
        self.alpha = 1.0f;
        self.hidden = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeStatusBarFrame:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        [self rotateStatusBarFrame];
        [self configure];
    }
    
    return self;
}

-(void)configure
{
    CGRect backgroundFrame = self.frame;
    UIView *view = [[UIView alloc] initWithFrame:backgroundFrame];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:view];
    self.backgroundView = view;
}

#pragma mark - UIWindow

- (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didChangeStatusBarFrame:(NSNotification *)notification
{
    [self performSelector:@selector(rotateStatusBarFrame)];
}

- (void)applicationWillResignActive:(NSNotification *)notifaction
{
    self.disabled = YES;
    [self setHidden:self.hidden animated:YES];
}

- (void)applicationDidBecomeActive:(NSNotification *)notifaction
{
    self.disabled = NO;
    [self setHidden:self.hidden animated:YES];
}

- (void)show
{
    [self setHidden:NO animated:YES];
}

- (void)hide
{
    [self setHidden:YES animated:YES];
}

- (void)setHidden:(BOOL)hidden
{
    [self setHidden:hidden animated:NO];
}

- (BOOL)isHidden
{
    return (self.reallyHidden || self.disabled);
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    self.reallyHidden = hidden;
    super.hidden = (hidden || self.disabled);
}

- (void)rotateStatusBarFrame
{
    // current interface orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    BOOL visibleBeforeTransformation = !self.hidden;
    
    // hide and then unhide after rotation
    if (visibleBeforeTransformation) {
        [self setHidden:YES animated:NO];
    }
    
    CGFloat pi = (CGFloat)M_PI;
    if (orientation == UIDeviceOrientationPortrait) {
        self.transform = CGAffineTransformIdentity;
        self.frame = CGRectMake(0.f,0.f,kScreenWidth,kScreenHeight);
    }else if (orientation == UIDeviceOrientationLandscapeLeft) {
        self.transform = CGAffineTransformMakeRotation(pi / 2.0f);
        self.frame = CGRectMake(kScreenWidth - kScreenHeight,0.0f, kScreenHeight, kScreenHeight);
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        self.transform = CGAffineTransformMakeRotation(pi / -2.0f);
        self.frame = CGRectMake(0.f,0.f, kScreenHeight, kScreenHeight);
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        self.transform = CGAffineTransformMakeRotation(pi);
        self.frame = CGRectMake(0.f,0.0f,kScreenWidth,kScreenHeight);
    }
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(0.f,0.f,kScreenWidth,kScreenHeight);
    
    // make visible after given time
    if (visibleBeforeTransformation) {
        
        [UIView animateWithDuration:kAppearAnimationDuration
                              delay:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self setHidden:NO animated:YES];
                         }
                         completion:NULL];
    }
}


@end
