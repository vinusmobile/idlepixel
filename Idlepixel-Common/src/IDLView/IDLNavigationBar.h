//
//  IDLNavigationBar.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 20/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLActionTarget.h"
#import "IDLObjectProtocols.h"
#import "IDLInterfaceProtocols.h"

extern NSString * const kIDLNavigationBarMultiTapReceivedNotification;

@class IDLNavigationBar;

@protocol IDLNavigationBarButtonDelegate <NSObject>

@required
-(void)navigationBar:(IDLNavigationBar *)bar leftButtonTappedWithIndex:(NSUInteger)indexFromLeft;
-(void)navigationBar:(IDLNavigationBar *)bar rightButtonTappedWithIndex:(NSUInteger)indexFromRight;

@end

@interface IDLNavigationBar : UINavigationBar <IDLActionTarget, IDLConfigurable, IDLLayoutOnAwakeFromNib>

+(void)setPreferredBarHeight:(CGFloat)barHeight;
+(CGFloat)preferredBarHeight;

@property (readonly) CGSize squareButtonSize;

@property (nonatomic, weak) NSObject<IDLNavigationBarButtonDelegate> *buttonDelegate;

@property (nonatomic, assign) CGFloat barHeight;

@property (nonatomic, strong) UIView *customBackgroundView;
@property (nonatomic, strong) UIView *flairBackgroundView;

@property (nonatomic, strong) NSArray *leftBarViews;
@property (nonatomic, strong) NSArray *rightBarViews;

@property (nonatomic, strong) UIView *leftAlignedOverlayView;
@property (nonatomic, strong) UIView *rightAlignedOverlayView;

@property (nonatomic, strong, readonly) UIView *backgroundContainer;
@property (nonatomic, strong, readonly) UIView *leftBarViewsContainer;
@property (nonatomic, strong, readonly) UIView *rightBarViewsContainer;
@property (nonatomic, strong, readonly) UIView *leftAlignedOverlayContainer;
@property (nonatomic, strong, readonly) UIView *rightAlignedOverlayContainer;

@property (nonatomic, strong, readonly) UIView *centeredViewContainer;

@property (nonatomic, assign) BOOL multiTapNotificationEnabled;
@property (nonatomic, assign) NSInteger multiTapNotificationTouchesRequired;
@property (nonatomic, assign) NSInteger multiTapNotificationTapsRequired;

@end
