//
//  UIViewController+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIViewController+Idlepixel.h"
#import "UIApplication+Idlepixel.h"
#import "UINavigationItem+Idlepixel.h"
#import "IDLInterfaceProtocols.h"

@implementation UIViewController (IDLViewVisible)

-(BOOL)isViewVisible
{
    return ([self isViewLoaded] && self.view.window && [[UIApplication sharedApplication] viewVisible:self.view]);
}

@end

@implementation UIViewController (IDLViewTop)

-(BOOL)isTopViewController
{
    BOOL result = (self == self.navigationController.topViewController);
    if (!result) {
        result = (self == self.tabBarController.selectedViewController);
    }
    if (!result) {
        UIViewController *parentVC = self.parentViewController;
        if (parentVC && [parentVC respondsToSelector:@selector(topViewController)]) {
            result = (self == [(UINavigationController *)parentVC topViewController]);
        }
        if (!result && parentVC && [parentVC respondsToSelector:@selector(selectedViewController)]) {
            result = (self == [(UITabBarController *)parentVC selectedViewController]);
        }
    }
    return result;
}

@end

@implementation UIViewController (IDLStoryboardIdentifier)

#define kUIViewControllerAssociatedObjectStoryboardIdentifier       @"UIViewControllerAssociatedObjectStoryboardIdentifier"

- (void)setStoryboardIdentifier:(NSString *)storyboardIdentifier
{
    storyboardIdentifier = CLASS_OR_NIL(storyboardIdentifier, NSString);
    objc_setAssociatedObject(self, kUIViewControllerAssociatedObjectStoryboardIdentifier, storyboardIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)storyboardIdentifier
{
    return objc_getAssociatedObject(self, kUIViewControllerAssociatedObjectStoryboardIdentifier);
}

- (NSString *)storyboardOrTypeIdentifier
{
    NSString *identifier = self.storyboardIdentifier;
    if (identifier == nil && [self respondsToSelector:@selector(typeIdentifier)]) {
        identifier = [(id <IDLTypedViewController>)self typeIdentifier];
    }
    return identifier;
}

@end

@implementation UIViewController (IDLSubtitle)

- (void)setSubtitle:(NSString *)subtitle
{
    self.navigationItem.subtitle = subtitle;
}

- (NSString *)subtitle
{
    return self.navigationItem.subtitle;
}

-(void)refreshNavigationTitle
{
    NSString *title = self.title;
    if (title != nil) {
        self.title = nil;
    } else {
        self.title = @" ";
    }
    self.title = title;
}

@end

@implementation UIViewController (IDLDisablePop)

#define kUIViewControllerAssociatedObjectDisablePopViewController       @"UIViewControllerAssociatedObjectDisablePopViewController"

- (void)setDisablePopViewController:(BOOL)disablePopViewController
{
    objc_setAssociatedObject(self, kUIViewControllerAssociatedObjectDisablePopViewController, @(disablePopViewController), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)disablePopViewController
{
    return [(NSNumber *)objc_getAssociatedObject(self, kUIViewControllerAssociatedObjectDisablePopViewController) boolValue];
}

@end
