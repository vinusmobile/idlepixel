//
//  IDLViewControllerManager.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 14/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLViewControllerManager.h"
#import "NSObject+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

@interface IDLViewControllerManager ()

@property (nonatomic, strong) NSDictionary *typedViewControllers;

@end

@implementation IDLViewControllerManager

+(instancetype)sharedManager
{
    return [self preferredSingleton];
}

+ (Class)viewControllerClassWithTypeIdentifier:(NSString *)typeIdentifier
{
    return [[self sharedManager] viewControllerClassWithTypeIdentifier:typeIdentifier];
}

+ (UIViewController<IDLTypedViewController> *)platformSubclassInstanceWithTypeIdentifier:(NSString *)typeIdentifier
{
    return [[self sharedManager] platformSubclassInstanceWithTypeIdentifier:typeIdentifier];
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
    if (self.typedViewControllers != nil) return;
    
    //IDLLogContext(@"INITIALISING");
    
    UIUserInterfaceIdiom currentInterfaceIdiom = self.userInterfaceIdiom;
    
    IDLTypedUserInterfaceIdiom typeInterfaceIdiom;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *subclasses = [UIViewController allSubclasses];
    Protocol *typedProtocol = @protocol(IDLTypedViewController);
    Protocol *initProtocol = @protocol(IDLViewControllerManagerInitializable);
    NSString *type = nil;
    NSArray *types = nil;
    
    BOOL conflictsFound = NO;
    
    for (Class aClass in subclasses) {
        if (ClassOrSuperclassConformsToProtocol(aClass, typedProtocol)) {
            if ([aClass respondsToSelector:@selector(typeUserInterface)]) {
                typeInterfaceIdiom = [aClass typeUserInterface];
            } else {
                typeInterfaceIdiom = IDLTypedUserInterfaceIdiomUnspecified;
            }
            if (typeInterfaceIdiom == IDLTypedUserInterfaceIdiomUnspecified || typeInterfaceIdiom == (IDLTypedUserInterfaceIdiom)currentInterfaceIdiom) {
                
                if ([aClass respondsToSelector:@selector(typeIdentifiers)]) {
                    types = [aClass typeIdentifiers];
                } else {
                    types = nil;
                }
                
                type = [aClass typeIdentifier];
                
                if (types.count > 0 && type != nil) {
                    types = [types arrayByAddingObject:type];
                } else if (type != nil) {
                    types = @[type];
                }
                
                if (types.count > 0) {
                    for (type in types) {
                        BOOL added = AddUniqueClassToDictionaryWithKey(dictionary, aClass, type);
                        if (!added) {
                            NSLog(@"*** %@ CONFLICT ENCOUNTERED: '%@' provided by [%@, %@] ***",self.className,type,[dictionary objectForKey:type],[aClass className]);
                            conflictsFound = YES;
                        }
                    }
                }
                //} else {
                //    IDLLog(@"ignoring %@ due to mismatched platforms",[aClass className]);
            }
        }
        if (ClassOrSuperclassConformsToProtocol(aClass, initProtocol)) {
            if ([aClass respondsToSelector:@selector(initializeWithViewControllerManager)]) {
                [aClass initializeWithViewControllerManager];
            }
        }
    }
    
    if (conflictsFound) {
        NSLog(@"*** %@ Registered View Controllers:\n%@\n***", self.className,dictionary);
        NSAssert(!conflictsFound, @"View Controllers conforming to IDLTypedViewController must provide UNIQUE Type Identifiers");
    }
    
    self.typedViewControllers = [NSDictionary dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)registeredTypedViewControllers
{
    return [self.typedViewControllers copy];
}

- (Class)viewControllerClassWithTypeIdentifier:(NSString *)typeIdentifier
{
    if (typeIdentifier != nil) {
        return [self.typedViewControllers objectForKey:typeIdentifier];
    } else {
        return nil;
    }
}

- (UIViewController<IDLTypedViewController> *)platformSubclassInstanceWithTypeIdentifier:(NSString *)typeIdentifier
{
    Class controllerClass = [self viewControllerClassWithTypeIdentifier:typeIdentifier];
    
    UIViewController<IDLTypedViewController> *vc = nil;
    if (controllerClass != nil) {
        vc = [controllerClass platformSubclassInstanceWithNib];
    }
    return vc;
}

@end
