//
//  IDLActionTarget.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 13/05/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDLActionTarget <NSObject>

@required
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target;

@end

@interface IDLActionTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) UIControlEvents controlEvents;

+ (IDLActionTarget*) actionWithTarget:(id)target selector:(SEL)selector controlEvents:(UIControlEvents)controlEvents;

@end

@interface IDLActionTargetSet : NSObject <IDLActionTarget>

- (NSArray *)allActionTargets;
- (NSSet *)allTargets;
- (UIControlEvents)allControlEvents;
- (NSArray *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent;
- (NSArray *)actionsForControlEvent:(UIControlEvents)controlEvent;
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents sender:(id)sender;

@end
