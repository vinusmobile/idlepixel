//
//  IDLOverlayWindow.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/12/2013.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLObjectProtocols.h"

@interface IDLOverlayWindow : UIWindow <IDLConfigurable>

// Singleton Instance
+ (instancetype)sharedInstance;
+ (instancetype)sharedOverlay;

- (void)hide;
- (void)show;

@end
