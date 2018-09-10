//
//  IDLActionTarget.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 13/05/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLActionTarget.h"
#import "IDLMacroHeaders.h"
#import "IDLNSInlineExtensions.h"
#import "NSObject+Idlepixel.h"

@implementation IDLActionTarget

+ (IDLActionTarget*) actionWithTarget:(id)target selector:(SEL)selector controlEvents:(UIControlEvents)controlEvents
{
    IDLActionTarget *a = [IDLActionTarget new];
    a.target = target;
    a.selector = selector;
    a.controlEvents = controlEvents;
    return a;
}

- (BOOL) isEqual:(id)object
{
    IDLComparisonResult comparison = NSObjectCompare(object, self);
    if (comparison == IDLComparisonResultInconclusive) {
        IDLActionTarget *action = (IDLActionTarget *)object;
        BOOL equal = (self.target == action.target) && (self.selector == action.selector);
        if (equal) equal = (self.controlEvents == action.controlEvents);
        return equal;
    }
    return comparison;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@[target=%@,selector='%@']",self.pointerKey,self.target,NSStringFromSelector(self.selector)];
}

@end

@interface IDLActionTargetSet ()

@property (nonatomic, strong) NSMutableOrderedSet *targetSet;

@end

@implementation IDLActionTargetSet

- (id) init
{
    self = [super init];
    if (self) {
        self.targetSet = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    IDLActionTarget *actionTarget = [IDLActionTarget actionWithTarget:target selector:action controlEvents:controlEvents];
    [self.targetSet addObject:actionTarget];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    NSArray *array = self.targetSet.array;
    for (IDLActionTarget *actionTarget in array) {
        if (actionTarget.target == target) {
            if (action == nil || action == actionTarget.selector) {
                actionTarget.controlEvents = actionTarget.controlEvents & ~controlEvents;
                
                if (actionTarget.controlEvents == 0) {
                    [self.targetSet removeObject:actionTarget];
                }
            }
        }
    }
}

- (void)removeTarget:(id)target
{
    [self removeTarget:target action:nil forControlEvents:UIControlEventAllEvents];
}

- (NSArray *)allActionTargets
{
    return [self.targetSet array];
}

- (NSSet *)allTargets
{
    NSMutableSet *set = [NSMutableSet set];
    NSArray *array = self.targetSet.array;
    for (IDLActionTarget *actionTarget in array) {
        if (actionTarget.target) {
            [set addObject:actionTarget.target];
        }
    }
    return [NSSet setWithSet:set];
}

- (UIControlEvents)allControlEvents
{
    UIControlEvents events = 0;
    
    NSArray *array = self.targetSet.array;
    for (IDLActionTarget *actionTarget in array) {
        events = events | actionTarget.controlEvents;
    }
    return events;
}

- (NSArray *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *targets = self.targetSet.array;
    for (IDLActionTarget *actionTarget in targets) {
        if (target == nil || actionTarget == target) {
            if (controlEvent & actionTarget.controlEvents) {
                if (actionTarget.selector != nil) {
                    [array addObject:NSStringFromSelector(actionTarget.selector)];
                }
            }
        }
    }
    return [NSArray arrayWithArray:array];
}

- (NSArray *)actionsForControlEvent:(UIControlEvents)controlEvent
{
    return [self actionsForTarget:nil forControlEvent:controlEvent];
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents sender:(id)sender
{
    NSArray *targets = self.targetSet.array;
    for (IDLActionTarget *actionTarget in targets) {
        if (controlEvents & actionTarget.controlEvents) {
            if (actionTarget.selector != nil && actionTarget.target != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [actionTarget.target performSelector: actionTarget.selector withObject: sender];
#pragma clang diagnostic pop
                
            }
        }
    }
}

-(void)dealloc
{
    self.targetSet = nil;
}

@end