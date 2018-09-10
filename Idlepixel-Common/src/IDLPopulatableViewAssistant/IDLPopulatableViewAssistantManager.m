//
//  IDLPopulatableViewAssistantManager.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLPopulatableViewAssistantManager.h"
#import "IDLNestedDictionary.h"
#import "NSObject+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

NSString * const kIDLPopulatableViewControllerAssistantIdentifierTableCell              = @"table.cell";
NSString * const kIDLPopulatableViewControllerAssistantIdentifierTableHeader            = @"table.header";
NSString * const kIDLPopulatableViewControllerAssistantIdentifierTableFooter            = @"table.footer";

NSString * const kIDLPopulatableViewControllerAssistantIdentifierCollectionCell         = @"collection.cell";
NSString * const kIDLPopulatableViewControllerAssistantIdentifierCollectionHeader       = @"collection.header";
NSString * const kIDLPopulatableViewControllerAssistantIdentifierCollectionFooter       = @"collection.footer";

@interface IDLPopulatableViewAssistantManager ()

@property (nonatomic, strong, readwrite) IDLNestedDictionary *associations;

@property (nonatomic, strong) IDLNestedDictionary *cachedAssistants;

@end

@implementation IDLPopulatableViewAssistantManager

#pragma mark - Common

+(instancetype)sharedManager
{
    return [self preferredSingleton];
}

-(id)init
{
    self = [super init];
    if (self) {
        self.associations = [[IDLNestedDictionary alloc] init];
        self.cachedAssistants = [[IDLNestedDictionary alloc] init];
    }
    return self;
}

-(void)clearViewControllerInstances:(UIViewController *)viewController
{
    if (viewController == nil) return;
    
    NSString *vcKey = viewController.pointerKey;
    
    if (vcKey != nil) {
        NSArray *keyArray = @[vcKey];
        [self.cachedAssistants removeObjectForKeys:keyArray];
    }
}

-(Protocol *)protocolForIdentifierType:(NSString *)identifierType
{
    if (NSStringEquals(identifierType, kIDLPopulatableViewControllerAssistantIdentifierTableCell)
        || NSStringEquals(identifierType, kIDLPopulatableViewControllerAssistantIdentifierTableCell)
        || NSStringEquals(identifierType, kIDLPopulatableViewControllerAssistantIdentifierTableCell)) {
        return @protocol(IDLPopulatableTableViewAssistant);
        
    } else if (NSStringEquals(identifierType, kIDLPopulatableViewControllerAssistantIdentifierCollectionCell)
               || NSStringEquals(identifierType, kIDLPopulatableViewControllerAssistantIdentifierCollectionHeader)
               || NSStringEquals(identifierType, kIDLPopulatableViewControllerAssistantIdentifierCollectionFooter)) {
        return @protocol(IDLPopulatableCollectionViewAssistant);
    }
    return nil;
}

-(void)registerAssistantClass:(Class)assistantClass identifierType:(NSString *)identifierType reuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier
{
    
    //IDLLogContext(@"%@ : %@, %@, %@",assistantClass,identifierType,reuseIdentifier,populatableIdentifier);
    
    if (assistantClass != nil && identifierType != nil && reuseIdentifier != nil) {
        Protocol *requiredProtocol = [self protocolForIdentifierType:identifierType];
        if (requiredProtocol == nil || [assistantClass conformsToProtocol:requiredProtocol]) {
            NSArray *keyArray = IDLPopulatableAssistantKeyArrayFromIdentifiers(identifierType, reuseIdentifier, populatableIdentifier);
            NSString *className = [assistantClass className];
            
            [self.associations setObject:className forKeys:keyArray];
        }
    }
}

-(id)assistantForIdentifierType:(NSString *)identifierType reuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier forViewController:(UIViewController *)viewController
{
    if (identifierType != nil && reuseIdentifier != nil) {
        NSString *className = (NSString *)[self.associations objectForKeys:IDLPopulatableAssistantKeyArrayFromIdentifiers(identifierType, reuseIdentifier, populatableIdentifier)];
        if (className == nil && populatableIdentifier != nil) {
            className = (NSString *)[self.associations objectForKeys:IDLPopulatableAssistantKeyArrayFromIdentifiers(identifierType, reuseIdentifier, nil)];
        }
        if (className != nil) {
            
            NSString *vcKey = @"undefined";
            if (viewController != nil) {
                vcKey = viewController.pointerKey;
            }
            
            NSArray *keyArray = nil;
            NSObject *assistant = nil;
            if (vcKey != nil) {
                keyArray = @[vcKey, className];
                assistant = [self.cachedAssistants objectForKeys:keyArray];
            }
            
            if (assistant == nil) {
                
                Class assistantClass = NSClassFromString(className);
                assistant = [[assistantClass class] assistantForViewController:viewController];
                
                if (keyArray != nil && assistant != nil) {
                    //IDLLog(@"CREATE: %@ for %@",assistant,vcKey);
                    [self.cachedAssistants setObject:(NSObject *)assistant forKeys:keyArray];
                }
            }
            return assistant;
        }
    }
    return nil;
}

#pragma mark - Table View

-(void)registerAssistantClass:(Class)assistantClass tableReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerAssistantClass:assistantClass tableReuseIdentifier:reuseIdentifier populatableIdentifier:nil];
}

-(void)registerAssistantClass:(Class)assistantClass tableReuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier
{
    if (assistantClass != nil && reuseIdentifier != nil) {
        [self registerAssistantClass:assistantClass identifierType:kIDLPopulatableViewControllerAssistantIdentifierTableCell reuseIdentifier:reuseIdentifier populatableIdentifier:populatableIdentifier];
    }
}

-(void)registerAssistantClass:(Class)assistantClass tableHeaderReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerAssistantClass:assistantClass tableHeaderReuseIdentifier:reuseIdentifier populatableIdentifier:nil];
}

-(void)registerAssistantClass:(Class)assistantClass tableHeaderReuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier
{
    if (assistantClass != nil && reuseIdentifier != nil) {
        [self registerAssistantClass:assistantClass identifierType:kIDLPopulatableViewControllerAssistantIdentifierTableHeader reuseIdentifier:reuseIdentifier populatableIdentifier:populatableIdentifier];
    }
}

-(void)registerAssistantClass:(Class)assistantClass tableFooterReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerAssistantClass:assistantClass tableFooterReuseIdentifier:reuseIdentifier populatableIdentifier:nil];
}

-(void)registerAssistantClass:(Class)assistantClass tableFooterReuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier
{
    if (assistantClass != nil && reuseIdentifier != nil) {
        [self registerAssistantClass:assistantClass identifierType:kIDLPopulatableViewControllerAssistantIdentifierTableFooter reuseIdentifier:reuseIdentifier populatableIdentifier:populatableIdentifier];
    }
}

-(id<IDLPopulatableTableViewAssistant>)tableViewAssistantForInterfaceItem:(IDLInterfaceItem *)interfaceItem viewController:(UIViewController *)viewController
{
    return [self assistantForIdentifierType:kIDLPopulatableViewControllerAssistantIdentifierTableCell reuseIdentifier:interfaceItem.reuseIdentifier populatableIdentifier:interfaceItem.populatableAssistantIdentifier forViewController:viewController];
}

-(id<IDLPopulatableTableViewAssistant>)tableViewAssistantForInterfaceSectionHeader:(IDLInterfaceSection *)interfaceSection viewController:(UIViewController *)viewController
{
    return [self assistantForIdentifierType:kIDLPopulatableViewControllerAssistantIdentifierTableHeader reuseIdentifier:interfaceSection.headerReuseIdentifier populatableIdentifier:interfaceSection.headerPopulatableAssistantIdentifier forViewController:viewController];
}

-(id<IDLPopulatableTableViewAssistant>)tableViewAssistantForInterfaceSectionFooter:(IDLInterfaceSection *)interfaceSection viewController:(UIViewController *)viewController
{
    return [self assistantForIdentifierType:kIDLPopulatableViewControllerAssistantIdentifierTableFooter reuseIdentifier:interfaceSection.footerReuseIdentifier populatableIdentifier:interfaceSection.footerPopulatableAssistantIdentifier forViewController:viewController];
}

#pragma mark - Collection View

-(void)registerAssistantClass:(Class)assistantClass collectionReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerAssistantClass:assistantClass collectionReuseIdentifier:reuseIdentifier populatableIdentifier:nil];
}

-(void)registerAssistantClass:(Class)assistantClass collectionReuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier
{
    if (assistantClass != nil && reuseIdentifier != nil) {
        [self registerAssistantClass:assistantClass identifierType:kIDLPopulatableViewControllerAssistantIdentifierCollectionCell reuseIdentifier:reuseIdentifier populatableIdentifier:populatableIdentifier];
    }
}

-(void)registerAssistantClass:(Class)assistantClass collectionHeaderReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerAssistantClass:assistantClass collectionHeaderReuseIdentifier:reuseIdentifier populatableIdentifier:nil];
}

-(void)registerAssistantClass:(Class)assistantClass collectionHeaderReuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier
{
    if (assistantClass != nil && reuseIdentifier != nil) {
        [self registerAssistantClass:assistantClass identifierType:kIDLPopulatableViewControllerAssistantIdentifierCollectionHeader reuseIdentifier:reuseIdentifier populatableIdentifier:populatableIdentifier];
    }
}

-(void)registerAssistantClass:(Class)assistantClass collectionFooterReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerAssistantClass:assistantClass collectionFooterReuseIdentifier:reuseIdentifier populatableIdentifier:nil];
}

-(void)registerAssistantClass:(Class)assistantClass collectionFooterReuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier
{
    if (assistantClass != nil && reuseIdentifier != nil) {
        [self registerAssistantClass:assistantClass identifierType:kIDLPopulatableViewControllerAssistantIdentifierCollectionFooter reuseIdentifier:reuseIdentifier populatableIdentifier:populatableIdentifier];
    }
}

-(id<IDLPopulatableCollectionViewAssistant>)collectionViewAssistantForInterfaceItem:(IDLInterfaceItem *)interfaceItem viewController:(UIViewController *)viewController
{
    return [self assistantForIdentifierType:kIDLPopulatableViewControllerAssistantIdentifierCollectionCell reuseIdentifier:interfaceItem.reuseIdentifier populatableIdentifier:interfaceItem.populatableAssistantIdentifier forViewController:viewController];
}

-(id<IDLPopulatableCollectionViewAssistant>)collectionViewAssistantForInterfaceSection:(IDLInterfaceSection *)interfaceSection supplementaryViewKind:(NSString *)supplementaryViewKind viewController:(UIViewController *)viewController
{
    if (NSStringEquals(supplementaryViewKind, UICollectionElementKindSectionHeader)) {
        return [self collectionViewAssistantForInterfaceSectionHeader:interfaceSection viewController:viewController];
    } else if (NSStringEquals(supplementaryViewKind, UICollectionElementKindSectionFooter)) {
        return [self collectionViewAssistantForInterfaceSectionFooter:interfaceSection viewController:viewController];
    } else {
        return nil;
    }
}

-(id<IDLPopulatableCollectionViewAssistant>)collectionViewAssistantForInterfaceSectionHeader:(IDLInterfaceSection *)interfaceSection viewController:(UIViewController *)viewController
{
    return [self assistantForIdentifierType:kIDLPopulatableViewControllerAssistantIdentifierCollectionHeader reuseIdentifier:interfaceSection.headerReuseIdentifier populatableIdentifier:interfaceSection.headerPopulatableAssistantIdentifier forViewController:viewController];
}

-(id<IDLPopulatableCollectionViewAssistant>)collectionViewAssistantForInterfaceSectionFooter:(IDLInterfaceSection *)interfaceSection viewController:(UIViewController *)viewController
{
    return [self assistantForIdentifierType:kIDLPopulatableViewControllerAssistantIdentifierCollectionFooter reuseIdentifier:interfaceSection.footerReuseIdentifier populatableIdentifier:interfaceSection.footerPopulatableAssistantIdentifier forViewController:viewController];
}

@end
