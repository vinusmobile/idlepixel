//
//  IDLNavigationController.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 24/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLNavigationController.h"
#import "UIViewController+Idlepixel.h"

@interface IDLNavigationController ()

@end

@implementation IDLNavigationController

-(id)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) [self configure];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self configure];
    return self;
}

-(id)init
{
    self = [super init];
    if (self) [self configure];
    return self;
}

-(void)dealloc
{
    [self removeObservers];
}

-(void)configure
{
    [self setupObservers];
    self.customNavigationBar.buttonDelegate = self;
    self.backButtonLeftIndex = NSNotFound;
    self.backButtonRightIndex = NSNotFound;
}

-(void)setupObservers
{
    // do nothing, meant for override
}

-(void)removeObservers
{
    // do nothing, meant for override
}

-(void)notificationObserved:(NSNotification *)notification
{
    // do nothing, meant for override
}

-(IDLNavigationBar *)customNavigationBar
{
    RETURN_IF_CLASS(self.navigationBar, IDLNavigationBar);
}

-(void)navigationBar:(IDLNavigationBar *)bar leftButtonTappedWithIndex:(NSUInteger)indexFromLeft
{
    if (indexFromLeft == self.backButtonLeftIndex) {
        [self popViewControllerAnimated:YES];
    }
}

-(void)navigationBar:(IDLNavigationBar *)bar rightButtonTappedWithIndex:(NSUInteger)indexFromRight
{
    if (indexFromRight == self.backButtonRightIndex) {
        [self popViewControllerAnimated:YES];
    }
}

-(UIGestureRecognizer *)interactivePopGestureRecognizer
{
    if ([[UINavigationController class] respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        return [super interactivePopGestureRecognizer];
    } else {
        return nil;
    }
}

#pragma mark - push/pop

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (!self.topViewController.disablePopViewController) {
        return [super popViewControllerAnimated:animated];
    } else {
        return nil;
    }
}

@end
