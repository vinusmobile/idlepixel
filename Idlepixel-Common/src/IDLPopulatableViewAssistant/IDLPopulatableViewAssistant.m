//
//  IDLPopulatableViewAssistant.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLPopulatableViewAssistant.h"

@implementation IDLPopulatableViewAssistant

+(id)assistantForViewController:(UIViewController *)controller
{
    IDLPopulatableViewAssistant *assistant = [[[self class] alloc] init];
    assistant.viewController = controller;
    return assistant;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.viewController = nil;
    }
    return self;
}

#pragma mark - Table View

-(BOOL)populateCell:(UITableViewCell *)cell withItem:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay
{
    //IDLLogContext(@"%@ - %@",indexPath,interfaceItem.comparisonIdentifier.identifier);
    return NO;
}

-(BOOL)populateHeaderView:(UITableViewHeaderFooterView *)view withSection:(IDLInterfaceSection *)interfaceSection section:(NSInteger)section forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay
{
    //IDLLogContext(@"%i - %@",section,interfaceSection.comparisonIdentifier.identifier);
    return NO;
}

-(BOOL)populateFooterView:(UITableViewHeaderFooterView *)view withSection:(IDLInterfaceSection *)interfaceSection section:(NSInteger)section forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay
{
    //IDLLogContext(@"%i - %@",section,interfaceSection.comparisonIdentifier.identifier);
    return NO;
}

#pragma mark - Collection View

-(BOOL)populateCell:(UITableViewCell *)cell withItem:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView forDisplay:(BOOL)forDisplay
{
    //IDLLogContext(@"%@ - %@",indexPath,interfaceItem.comparisonIdentifier.identifier);
    return NO;
}

-(BOOL)populateSupplementaryView:(UICollectionReusableView *)cell ofKind:(NSString *)kind withSection:(IDLInterfaceSection *)interfaceSection atIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView forDisplay:(BOOL)forDisplay
{
    //IDLLogContext(@"%i - %@",section,interfaceSection.comparisonIdentifier.identifier);
    return NO;
}

@end
