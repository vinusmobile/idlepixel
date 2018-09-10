//
//  IDLPopulatableViewProtocols.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 26/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IDLInterfaceTypedefs.h"
#import "IDLInterfaceDataSourceHeaders.h"

@class IDLPopulatableViewAssistantManager;

@protocol IDLPopulatableViewController <NSObject>

@required
-(IDLPopulatableViewAssistantManager *)populatableAssistantManager;
+(void)registerPopulatableViewControllerAssistants:(IDLPopulatableViewAssistantManager *)manager;

@end

@protocol IDLPopulatableViewControllerAssistant <NSObject>

@required
+(id)assistantForViewController:(UIViewController *)controller;

@end

@protocol IDLPopulatableTableViewDelegate <NSObject>

@required
-(BOOL)populateCell:(UITableViewCell *)cell withItem:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay;
-(BOOL)populateHeaderView:(UITableViewHeaderFooterView *)view withSection:(IDLInterfaceSection *)interfaceSection section:(NSInteger)section forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay;
-(BOOL)populateFooterView:(UITableViewHeaderFooterView *)view withSection:(IDLInterfaceSection *)interfaceSection section:(NSInteger)section forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay;

@end

@protocol IDLPopulatableTableViewController <IDLPopulatableViewController, IDLPopulatableTableViewDelegate>
@end

@protocol IDLPopulatableTableViewAssistant <IDLPopulatableTableViewDelegate, IDLPopulatableViewControllerAssistant>
@end

@protocol IDLPopulatableCollectionViewDelegate <NSObject>

@required
-(BOOL)populateCell:(UICollectionViewCell *)cell withItem:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView forDisplay:(BOOL)forDisplay;
-(BOOL)populateSupplementaryView:(UICollectionReusableView *)view ofKind:(NSString *)kind withSection:(IDLInterfaceSection *)interfaceSection atIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView forDisplay:(BOOL)forDisplay;

@optional
-(CGSize)calculatedSizeForItemAtIndexPath:(NSIndexPath *)indexPath withItem:(IDLInterfaceItem *)interfaceItem forCollectionView:(UICollectionView *)collectionView success:(BOOL *)success;
-(CGSize)calculatedSizeForSupplementaryViewOfKind:(NSString *)kind withSection:(IDLInterfaceSection *)interfaceSection forCollectionView:(UICollectionView *)collectionView success:(BOOL *)success;

@end

@protocol IDLPopulatableCollectionViewController <IDLPopulatableViewController, IDLPopulatableCollectionViewDelegate>
@end

@protocol IDLPopulatableCollectionViewAssistant <IDLPopulatableCollectionViewDelegate, IDLPopulatableViewControllerAssistant>
@end
