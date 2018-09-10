//
//  IDLPopulatableViewAssistantManager.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLAbstractSharedSingleton.h"
#import "IDLInterfaceDataSourceHeaders.h"
#import "IDLPopulatableViewAssistant.h"
#import "IDLNestedDictionary.h"

NS_INLINE NSArray *IDLPopulatableAssistantKeyArrayFromIdentifiers(NSString *identifierType, NSString *reuseIdentifier, NSString *populatableIdentifier) {
    
    if (populatableIdentifier == nil) {
        populatableIdentifier = (NSString *)[NSNull null];
    }
    
    return @[identifierType, reuseIdentifier, populatableIdentifier];
    
}

extern NSString * const kIDLPopulatableViewControllerAssistantIdentifierTableCell;
extern NSString * const kIDLPopulatableViewControllerAssistantIdentifierTableHeader;
extern NSString * const kIDLPopulatableViewControllerAssistantIdentifierTableFooter;

extern NSString * const kIDLPopulatableViewControllerAssistantIdentifierCollectionCell;
extern NSString * const kIDLPopulatableViewControllerAssistantIdentifierCollectionHeader;
extern NSString * const kIDLPopulatableViewControllerAssistantIdentifierCollectionFooter;

@interface IDLPopulatableViewAssistantManager : IDLAbstractSharedSingleton

+(instancetype)sharedManager;

@property (nonatomic, strong, readonly) IDLNestedDictionary *associations;

-(void)clearViewControllerInstances:(UIViewController *)viewController;

-(void)registerAssistantClass:(Class)assistantClass identifierType:(NSString *)identifierType reuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier;

-(id)assistantForIdentifierType:(NSString *)identifierType reuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier forViewController:(UIViewController *)viewController;

// table view

-(void)registerAssistantClass:(Class)assistantClass tableReuseIdentifier:(NSString *)reuseIdentifier;
-(void)registerAssistantClass:(Class)assistantClass tableReuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier;
-(void)registerAssistantClass:(Class)assistantClass tableHeaderReuseIdentifier:(NSString *)headerReuseIdentifier;
-(void)registerAssistantClass:(Class)assistantClass tableHeaderReuseIdentifier:(NSString *)headerReuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier;
-(void)registerAssistantClass:(Class)assistantClass tableFooterReuseIdentifier:(NSString *)footerReuseIdentifier;
-(void)registerAssistantClass:(Class)assistantClass tableFooterReuseIdentifier:(NSString *)footerReuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier;

-(id<IDLPopulatableTableViewAssistant>)tableViewAssistantForInterfaceItem:(IDLInterfaceItem *)interfaceItem viewController:(UIViewController *)viewController;
-(id<IDLPopulatableTableViewAssistant>)tableViewAssistantForInterfaceSectionHeader:(IDLInterfaceSection *)interfaceSection viewController:(UIViewController *)viewController;
-(id<IDLPopulatableTableViewAssistant>)tableViewAssistantForInterfaceSectionFooter:(IDLInterfaceSection *)interfaceSection viewController:(UIViewController *)viewController;

// collection view

-(void)registerAssistantClass:(Class)assistantClass collectionReuseIdentifier:(NSString *)reuseIdentifier;
-(void)registerAssistantClass:(Class)assistantClass collectionReuseIdentifier:(NSString *)reuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier;
-(void)registerAssistantClass:(Class)assistantClass collectionHeaderReuseIdentifier:(NSString *)headerReuseIdentifier;
-(void)registerAssistantClass:(Class)assistantClass collectionHeaderReuseIdentifier:(NSString *)headerReuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier;
-(void)registerAssistantClass:(Class)assistantClass collectionFooterReuseIdentifier:(NSString *)footerReuseIdentifier;
-(void)registerAssistantClass:(Class)assistantClass collectionFooterReuseIdentifier:(NSString *)footerReuseIdentifier populatableIdentifier:(NSString *)populatableIdentifier;

-(id<IDLPopulatableCollectionViewAssistant>)collectionViewAssistantForInterfaceItem:(IDLInterfaceItem *)interfaceItem viewController:(UIViewController *)viewController;
-(id<IDLPopulatableCollectionViewAssistant>)collectionViewAssistantForInterfaceSection:(IDLInterfaceSection *)interfaceSection supplementaryViewKind:(NSString *)supplementaryViewKind viewController:(UIViewController *)viewController;
-(id<IDLPopulatableCollectionViewAssistant>)collectionViewAssistantForInterfaceSectionHeader:(IDLInterfaceSection *)interfaceSection viewController:(UIViewController *)viewController;
-(id<IDLPopulatableCollectionViewAssistant>)collectionViewAssistantForInterfaceSectionFooter:(IDLInterfaceSection *)interfaceSection viewController:(UIViewController *)viewController;

@end
