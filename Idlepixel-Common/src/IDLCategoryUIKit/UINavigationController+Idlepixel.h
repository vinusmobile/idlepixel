//
//  UINavigationController+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (IDLPopToViewController)

-(BOOL)popToViewControllerWithClass:(Class)viewControllerClass animated:(BOOL)animated;
-(BOOL)popToViewControllerWithTypeIdentifier:(NSString *)typeIdentifier animated:(BOOL)animated;
-(BOOL)popToViewControllerWithNavigationAnchor:(NSString *)navigationAnchor animated:(BOOL)animated;
-(BOOL)popToPreviousNavigationAnchorViewController:(BOOL)animated;

-(UIViewController *)viewControllerWithClass:(Class)viewControllerClass;
-(UIViewController *)viewControllerWithClass:(Class)viewControllerClass searchBackwards:(BOOL)searchBackwards;
-(UIViewController *)viewControllerWithTypeIdentifier:(NSString *)typeIdentifier;
-(UIViewController *)viewControllerWithTypeIdentifier:(NSString *)typeIdentifier searchBackwards:(BOOL)searchBackwards;
-(UIViewController *)viewControllerWithNavigationAnchor:(NSString *)navigationAnchor;
-(UIViewController *)viewControllerWithNavigationAnchor:(NSString *)navigationAnchor searchBackwards:(BOOL)searchBackwards;

-(void)pushViewController:(UIViewController *)pushController afterPoppingToViewController:(UIViewController *)popController animated:(BOOL)animated;
-(void)pushViewController:(UIViewController *)pushController afterPoppingToViewControllerWithClass:(Class)popControllerClass animated:(BOOL)animated;
-(void)pushViewController:(UIViewController *)pushController afterPoppingToViewControllerWithTypeIdentifier:(NSString *)popTypeIdentifier animated:(BOOL)animated;
-(void)pushViewController:(UIViewController *)pushController afterPoppingToViewControllerWithNavigationAnchor:(NSString *)popNavigationAnchor animated:(BOOL)animated;
-(void)pushViewController:(UIViewController *)pushController afterPoppingToPreviousNavigationAnchorViewController:(BOOL)animated;

@property (readonly) UIViewController *previousViewController;
@property (readonly) UIViewController *previousNavigationAnchorViewController;

@property (readonly) UIViewController *rootViewController;

@end

@interface UINavigationController (IDLReplaceViewController)

-(void)replaceTopViewControllerWithViewController:(UIViewController *)controller animated:(BOOL)animated;

@end

@interface UINavigationController (IDLCustomTransitions)

// any transition

-(void)pushViewController:(UIViewController *)viewController transitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection;
-(void)popViewControllerWithTransitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection;
-(void)popToViewController:(UIViewController *)viewController transitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection;
-(void)replaceTopViewControllerWithViewController:(UIViewController *)controller transitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection;
-(void)setViewControllers:(NSArray *)controllers transitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection;

// fade

-(void)pushFadeViewController:(UIViewController *)viewController;
-(void)popFadeViewController;
-(void)popFadeToRootViewController;
-(void)popFadeToViewController:(UIViewController *)viewController;
-(void)replaceFadeTopViewControllerWithViewController:(UIViewController *)controller;
-(void)setViewControllersWithFade:(NSArray *)controllers;

@end

@interface UINavigationController (IDLInteractivePopGestureRecognizer)

@property (readwrite) BOOL disableInteractivePopGestureRecognizer;

@end
