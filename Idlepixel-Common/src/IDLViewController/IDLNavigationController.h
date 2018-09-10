//
//  IDLNavigationController.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 24/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLNavigationBar.h"
#import "IDLProtocolHeaders.h"

@interface IDLNavigationController : UINavigationController <IDLNavigationBarButtonDelegate, IDLConfigurable, IDLNotificationObservant>

@property (readonly) IDLNavigationBar *customNavigationBar;

@property (nonatomic, assign) NSInteger backButtonLeftIndex;
@property (nonatomic, assign) NSInteger backButtonRightIndex;

-(UIGestureRecognizer *)interactivePopGestureRecognizer;

@end
