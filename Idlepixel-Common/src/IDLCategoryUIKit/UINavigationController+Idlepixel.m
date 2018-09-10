//
//  UINavigationController+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UINavigationController+Idlepixel.h"
#import "IDLInterfaceProtocols.h"
#import "NSArray+Idlepixel.h"
#import "IDLNSInlineExtensions.h"
#import "CATransition+Idlepixel.h"

@implementation UINavigationController (IDLPopToViewController)

-(BOOL)popToViewControllerWithClass:(Class)viewControllerClass animated:(BOOL)animated
{
    UIViewController *vc = [self viewControllerWithClass:viewControllerClass];
    if (vc) {
        [self popToViewController:vc animated:animated];
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)popToViewControllerWithTypeIdentifier:(NSString *)typeIdentifier animated:(BOOL)animated
{
    UIViewController *vc = [self viewControllerWithTypeIdentifier:typeIdentifier];
    if (vc) {
        [self popToViewController:vc animated:animated];
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)popToViewControllerWithNavigationAnchor:(NSString *)navigationAnchor animated:(BOOL)animated
{
    UIViewController *vc = [self viewControllerWithNavigationAnchor:navigationAnchor];
    if (vc) {
        [self popToViewController:vc animated:animated];
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)popToPreviousNavigationAnchorViewController:(BOOL)animated
{
    UIViewController *vc = self.previousNavigationAnchorViewController;
    if (vc) {
        [self popToViewController:vc animated:animated];
        return YES;
    } else {
        return NO;
    }
}

-(UIViewController *)viewControllerWithClass:(Class)viewControllerClass
{
    return [self viewControllerWithClass:viewControllerClass searchBackwards:YES];
}

-(UIViewController *)viewControllerWithClass:(Class)viewControllerClass searchBackwards:(BOOL)searchBackwards
{
    NSArray *vcArray = [self.viewControllers copy];
    if (!searchBackwards) vcArray = vcArray.reversedArray;
    UIViewController *vc = nil;
    for (NSInteger i = (vcArray.count-1); i >= 0; i--) {
        vc = [vcArray objectAtIndex:i];
        if ([vc isKindOfClass:viewControllerClass]) {
            return vc;
        }
    }
    return nil;
}

-(UIViewController *)viewControllerWithTypeIdentifier:(NSString *)typeIdentifier
{
    return [self viewControllerWithTypeIdentifier:typeIdentifier searchBackwards:YES];
}

-(UIViewController *)viewControllerWithTypeIdentifier:(NSString *)typeIdentifier searchBackwards:(BOOL)searchBackwards
{
    NSArray *vcArray = [self.viewControllers copy];
    if (!searchBackwards) vcArray = vcArray.reversedArray;
    UIViewController *vc = nil;
    NSString *vcTypeIdentifier;
    for (NSInteger i = (vcArray.count-1); i >= 0; i--) {
        vc = [vcArray objectAtIndex:i];
        if ([vc respondsToSelector:@selector(typeIdentifier)]) {
            vcTypeIdentifier = [(id<IDLTypedViewController>)vc typeIdentifier];
            if (NSStringEquals(typeIdentifier, vcTypeIdentifier)) {
                return vc;
            }
        }
    }
    return nil;
}

-(UIViewController *)viewControllerWithNavigationAnchor:(NSString *)navigationAnchor
{
    return [self viewControllerWithNavigationAnchor:navigationAnchor searchBackwards:YES];
}

-(UIViewController *)viewControllerWithNavigationAnchor:(NSString *)navigationAnchor searchBackwards:(BOOL)searchBackwards
{
    NSArray *vcArray = [self.viewControllers copy];
    if (!searchBackwards) vcArray = vcArray.reversedArray;
    UIViewController *vc = nil;
    for (NSInteger i = (vcArray.count-1); i >= 0; i--) {
        vc = [vcArray objectAtIndex:i];
        if ([vc respondsToSelector:@selector(hasNavigationAnchor:)]) {
            if ([(id<IDLNavigationAnchor>)vc hasNavigationAnchor:navigationAnchor]) {
                return vc;
            }
        }
    }
    return nil;
}

-(void)pushViewController:(UIViewController *)pushController afterPoppingToViewController:(UIViewController *)popController animated:(BOOL)animated
{
    if (pushController != nil && popController != nil && pushController != popController) {
        NSArray *vcArray = [self.viewControllers copy];
        NSInteger index = [vcArray indexOfObject:popController];
        if (index != NSNotFound) {
            if (vcArray.lastObject != popController) vcArray = [vcArray subarrayToIndex:(index+1)];
            vcArray = [vcArray arrayByAddingObject:pushController];
            [self setViewControllers:vcArray animated:animated];
        }
    }
}

-(void)pushViewController:(UIViewController *)pushController afterPoppingToViewControllerWithClass:(Class)popControllerClass animated:(BOOL)animated
{
    UIViewController *popController = [self viewControllerWithClass:popControllerClass];
    [self pushViewController:pushController afterPoppingToViewController:popController animated:animated];
}

-(void)pushViewController:(UIViewController *)pushController afterPoppingToViewControllerWithTypeIdentifier:(NSString *)popTypeIdentifier animated:(BOOL)animated
{
    UIViewController *popController = [self viewControllerWithTypeIdentifier:popTypeIdentifier];
    [self pushViewController:pushController afterPoppingToViewController:popController animated:animated];
}

-(void)pushViewController:(UIViewController *)pushController afterPoppingToViewControllerWithNavigationAnchor:(NSString *)popNavigationAnchor animated:(BOOL)animated
{
    UIViewController *popController = [self viewControllerWithNavigationAnchor:popNavigationAnchor];
    [self pushViewController:pushController afterPoppingToViewController:popController animated:animated];
}

-(void)pushViewController:(UIViewController *)pushController afterPoppingToPreviousNavigationAnchorViewController:(BOOL)animated
{
    UIViewController *popController = [self previousNavigationAnchorViewController];
    [self pushViewController:pushController afterPoppingToViewController:popController animated:animated];
}

-(UIViewController *)previousViewController
{
    NSArray *controllers = [self.viewControllers copy];
    if (controllers.count > 2) {
        return [controllers objectAtIndex:(controllers.count - 2)];
    } else {
        return nil;
    }
}

-(UIViewController *)previousNavigationAnchorViewController
{
    NSArray *vcArray = [self.viewControllers copy];
    UIViewController *vc = nil;
    for (NSInteger i = (vcArray.count-1); i >= 0; i--) {
        vc = [vcArray objectAtIndex:i];
        if ([vc respondsToSelector:@selector(navigationAnchor)]) {
            NSString *anchor = [(id<IDLNavigationAnchor>)vc navigationAnchor];
            if (anchor) return vc;
        }
    }
    return nil;
}

-(UIViewController *)rootViewController
{
    return [self.viewControllers objectAtIndexOrNil:0];
}

@end

@implementation UINavigationController (IDLReplaceViewController)

-(void)replaceTopViewControllerWithViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if (controller != nil && self.topViewController != controller) {
        NSArray *controllers = [[self viewControllers] arrayByRemovingLastObject];
        controllers = [controllers arrayByAddingObject:controller];
        [self setViewControllers:controllers animated:animated];
    }
}

@end

@implementation UINavigationController (IDLCustomTransitions)

-(CATransition *)transitionWithType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection
{
    return [CATransition transitionWithType:transitionType subtype:transitionDirection duration:0.25f timingFunctionName:kCAMediaTimingFunctionEaseIn];
}

-(void)pushViewController:(UIViewController *)viewController transitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection
{
    CATransition* transition = [self transitionWithType:transitionType transitionDirection:transitionDirection];
    [self.view.layer removeAllAnimations];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self pushViewController:viewController animated:NO];
}

-(void)popViewControllerWithTransitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection
{
    CATransition* transition = [self transitionWithType:transitionType transitionDirection:transitionDirection];
    [self.view.layer removeAllAnimations];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self popViewControllerAnimated:NO];
}

-(void)popToViewController:(UIViewController *)viewController transitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection
{
    CATransition* transition = [self transitionWithType:transitionType transitionDirection:transitionDirection];
    [self.view.layer removeAllAnimations];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self popToViewController:viewController animated:NO];
}

-(void)replaceTopViewControllerWithViewController:(UIViewController *)controller transitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection
{
    CATransition* transition = [self transitionWithType:transitionType transitionDirection:transitionDirection];
    [self.view.layer removeAllAnimations];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self replaceTopViewControllerWithViewController:controller animated:NO];
}

-(void)setViewControllers:(NSArray *)controllers transitionType:(NSString *)transitionType transitionDirection:(NSString *)transitionDirection
{
    CATransition* transition = [self transitionWithType:transitionType transitionDirection:transitionDirection];
    [self.view.layer removeAllAnimations];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self setViewControllers:controllers animated:NO];
}

#define kTransitionFadeDirection    kCATransitionFromTop

-(void)pushFadeViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController transitionType:kCATransitionFade transitionDirection:kTransitionFadeDirection];
}

-(void)popFadeViewController
{
    [self popViewControllerWithTransitionType:kCATransitionFade transitionDirection:kTransitionFadeDirection];
}

-(void)popFadeToRootViewController
{
    [self popFadeToViewController:self.rootViewController];
}

-(void)popFadeToViewController:(UIViewController *)viewController
{
    [self popToViewController:viewController transitionType:kCATransitionFade transitionDirection:kTransitionFadeDirection];
}

-(void)replaceFadeTopViewControllerWithViewController:(UIViewController *)controller
{
    [self replaceTopViewControllerWithViewController:controller transitionType:kCATransitionFade transitionDirection:kTransitionFadeDirection];
}

-(void)setViewControllersWithFade:(NSArray *)controllers
{
    [self setViewControllers:controllers transitionType:kCATransitionFade transitionDirection:kTransitionFadeDirection];
}

@end

@implementation UINavigationController (IDLInteractivePopGestureRecognizer)

-(BOOL)disableInteractivePopGestureRecognizer
{
    if ([[UINavigationController class] respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        return ![self interactivePopGestureRecognizer].enabled;
    } else {
        return YES;
    }
}

-(void)setDisableInteractivePopGestureRecognizer:(BOOL)disableInteractivePopGestureRecognizer
{
    if ([[UINavigationController class] respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self interactivePopGestureRecognizer].enabled = !disableInteractivePopGestureRecognizer;
    }
}

@end



