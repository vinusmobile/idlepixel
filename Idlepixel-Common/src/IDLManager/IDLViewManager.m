//
//  IDLViewManager.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLViewManager.h"
#import "NSObject+Idlepixel.h"
#import "NSMutableArray+Idlepixel.h"
#import "IDLNSInlineExtensions.h"
#import "IDLLoggingMacros.h"

@interface IDLViewManager ()

@property (nonatomic, strong) NSDictionary *reuseIdentifiableViews;

@end

@implementation IDLViewManager

+(instancetype)sharedManager
{
    return [self preferredSingleton];
}

+ (Class)viewClassWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [[self sharedManager] viewClassWithReuseIdentifier:reuseIdentifier];
}

+ (NSSet *)viewClassesWithReuseIdentifiers:(NSSet *)reuseIdentifiers
{
    return [[self sharedManager] viewClassesWithReuseIdentifiers:reuseIdentifiers];
}

+ (UIView<IDLReuseIdentifiable> *)platformSubclassInstanceWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [[self sharedManager] platformSubclassInstanceWithReuseIdentifier:reuseIdentifier];
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    if (self.reuseIdentifiableViews != nil) return;
    
    //IDLLogContext(@"INITIALISING");
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *subclasses = [UIView allSubclasses];
    Protocol *reuseProtocol = @protocol(IDLReuseIdentifiable);
    NSString *reuseIdentifier = nil;
    
    BOOL conflictsFound = NO;
    
    for (Class aClass in subclasses) {
        if (ClassOrSuperclassConformsToProtocol(aClass, reuseProtocol)) {
            reuseIdentifier = [aClass reuseIdentifier];
            if (reuseIdentifier != nil) {
                BOOL added = AddUniqueClassToDictionaryWithKey(dictionary, aClass, reuseIdentifier);
                if (!added) {
                    NSLog(@"*** %@ CONFLICT ENCOUNTERED: '%@' provided by [%@, %@] ***",self.className,reuseIdentifier,[dictionary objectForKey:reuseIdentifier],[aClass className]);
                    conflictsFound = YES;
                }
            }
        }
    }
    
    if (conflictsFound) {
        NSLog(@"*** %@ Registered Views:\n%@\n***", self.className,dictionary);
        NSAssert(!conflictsFound, @"Views conforming to IDLReuseIdentifiable must provide UNIQUE Reuse Identifiers");
    }
    
    self.reuseIdentifiableViews = [NSDictionary dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)registeredReuseIdentifiableViews
{
    return [self.reuseIdentifiableViews copy];
}

- (Class)viewClassWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (reuseIdentifier != nil) {
        return [self.reuseIdentifiableViews objectForKey:reuseIdentifier];
    } else {
        return nil;
    }
}

- (NSSet *)viewClassesWithReuseIdentifiers:(NSSet *)reuseIdentifiers
{
    NSMutableSet *classes = [NSMutableSet set];
    
    for (NSString *identifier in reuseIdentifiers) {
        Class viewClass = [self viewClassWithReuseIdentifier:identifier];
        if (viewClass) [classes addObject:viewClass];
    }
    
    return [NSSet setWithSet:classes];
}

- (UIView<IDLReuseIdentifiable> *)platformSubclassInstanceWithReuseIdentifier:(NSString *)reuseIdentifier
{
    Class viewClass = [self viewClassWithReuseIdentifier:reuseIdentifier];
    
    //IDLLogObject(viewClass.className);
    
    UIView<IDLReuseIdentifiable> *view = nil;
    if (viewClass != nil) {
        view = [viewClass platformSubclassInstanceWithNib];
    }
    //IDLLogObject(view);
    return view;
}

@end
