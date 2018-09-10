//
//  IDLViewManager.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceProtocols.h"
#import "IDLAbstractSharedSingleton.h"

@interface IDLViewManager : IDLAbstractSharedSingleton

+ (instancetype)sharedManager;

+ (Class)viewClassWithReuseIdentifier:(NSString *)reuseIdentifier;
+ (NSSet *)viewClassesWithReuseIdentifiers:(NSSet *)reuseIdentifiers;
+ (UIView<IDLReuseIdentifiable> *)platformSubclassInstanceWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)initialize;

- (Class)viewClassWithReuseIdentifier:(NSString *)reuseIdentifier;
- (NSSet *)viewClassesWithReuseIdentifiers:(NSSet *)reuseIdentifiers;
- (UIView<IDLReuseIdentifiable> *)platformSubclassInstanceWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (readonly) NSDictionary *registeredReuseIdentifiableViews;

@end
