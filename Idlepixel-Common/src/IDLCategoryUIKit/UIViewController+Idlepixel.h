//
//  UIViewController+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (IDLViewVisible)

-(BOOL)isViewVisible;

@end

@interface UIViewController (IDLViewTop)

-(BOOL)isTopViewController;

@end

@interface UIViewController (IDLStoryboardIdentifier)

@property (readwrite) NSString *storyboardIdentifier;
@property (readonly) NSString *storyboardOrTypeIdentifier;

@end

@interface UIViewController (IDLSubtitle)

@property (readwrite) NSString *subtitle;

-(void)refreshNavigationTitle;

@end

@interface UIViewController (IDLDisablePop)

@property (readwrite) BOOL disablePopViewController;

@end
