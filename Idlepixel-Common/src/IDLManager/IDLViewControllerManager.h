//
//  IDLViewControllerManager.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 14/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceProtocols.h"
#import "IDLAbstractSharedSingleton.h"

@interface IDLViewControllerManager : IDLAbstractSharedSingleton

+ (instancetype)sharedManager;

+ (Class)viewControllerClassWithTypeIdentifier:(NSString *)typeIdentifier;
+ (UIViewController<IDLTypedViewController> *)platformSubclassInstanceWithTypeIdentifier:(NSString *)typeIdentifier;

- (void)initialize;

- (Class)viewControllerClassWithTypeIdentifier:(NSString *)typeIdentifier;
- (UIViewController<IDLTypedViewController> *)platformSubclassInstanceWithTypeIdentifier:(NSString *)typeIdentifier;

@property (readonly) NSDictionary *registeredTypedViewControllers;

@end
