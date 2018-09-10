//
//  IDLPopulatableCollectionViewMacros.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 26/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLPopulatableMacros.h"

#ifndef Idlepixel_Common_IDLPopulatableCollectionViewMacros_h
#define Idlepixel_Common_IDLPopulatableCollectionViewMacros_h

#pragma mark - IDLPopulatableCollectionViewDelegate -

// -(BOOL)populateCell:(UICollectionViewCell *)cell withItem:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView forDisplay:(BOOL)forDisplay

#define IDL_POPULATABLE_IDLPopulatableCollectionViewDelegate_populateCell() \
-(BOOL)populateCell:(UICollectionViewCell *)cell withItem:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView forDisplay:(BOOL)forDisplay\
{\
    BOOL populated = NO;\
    id<IDLPopulatableCollectionViewAssistant> assistant = [[IDLPopulatableViewAssistantManager sharedManager] collectionViewAssistantForInterfaceItem:interfaceItem viewController:self];\
    if (assistant != nil) {\
        populated = [assistant populateCell:cell withItem:interfaceItem atIndexPath:indexPath forCollectionView:collectionView forDisplay:forDisplay];\
    }\
    return populated;\
}

// -(BOOL)populateSupplementaryView:(UICollectionReusableView *)cell ofKind:(NSString *)kind withSection:(IDLInterfaceSection *)interfaceSection atIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView forDisplay:(BOOL)forDisplay

#define IDL_POPULATABLE_IDLPopulatableCollectionViewDelegate_populateSupplementaryView() \
-(BOOL)populateSupplementaryView:(UICollectionReusableView *)view ofKind:(NSString *)kind withSection:(IDLInterfaceSection *)interfaceSection atIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView forDisplay:(BOOL)forDisplay\
{\
    BOOL populated = NO;\
    id<IDLPopulatableCollectionViewAssistant> assistant = [self.populatableAssistantManager collectionViewAssistantForInterfaceSection:interfaceSection supplementaryViewKind:kind viewController:self];\
    if (assistant != nil) {\
        populated = [assistant populateSupplementaryView:view ofKind:kind withSection:interfaceSection atIndexPath:indexPath forCollectionView:collectionView forDisplay:forDisplay];\
    }\
    return populated;\
}

#pragma mark - UICollectionViewDatasource -

// - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

#define IDL_POPULATABLE_CollectionViewController_numberOfItemsInSection() \
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section \
{\
    return [[self interfaceDataSourceForView:collectionView] numberOfItemsInSection:section];\
}

// - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

#define IDL_POPULATABLE_CollectionViewController_numberOfSectionsInCollectionView() \
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView \
{\
    return [self interfaceDataSourceForView:collectionView].sectionCount;\
}

// - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

#define IDL_POPULATABLE_CollectionViewController_cellForItemAtIndexPath() \
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath\
{\
    /* Get the relevant item */ \
    IDLInterfaceItem *item = [[self interfaceDataSourceForView:collectionView] itemAtIndexPath:indexPath];\
    UICollectionViewCell *cell = nil;\
    \
    if (item.reuseIdentifier != nil) {\
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.reuseIdentifier forIndexPath:indexPath];\
    } else {\
        cell = [[UICollectionViewCell alloc] init];\
    }\
    cell.indexPath = indexPath;\
    \
    /* set the delegate if possible */ \
    if ([cell conformsToProtocol:@protocol(IDLActionResponseSource)]) {\
        [(id<IDLActionResponseSource>)cell setActionResponseDelegate:self];\
    }\
    \
    /* populate the cell */ \
    [self populateCell:cell withItem:item atIndexPath:indexPath forCollectionView:collectionView forDisplay:YES];\
    \
    /* update the layout */ \
    [cell setNeedsLayout];\
    \
    /* Return the cell */ \
    return cell;\
}

// - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

#define IDL_POPULATABLE_CollectionViewController_viewForSupplementaryElementOfKind() \
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath\
{\
    IDLInterfaceSection *interfaceSection = [[self interfaceDataSourceForView:collectionView] sectionAtIndex:indexPath.section];\
    UICollectionReusableView *view = nil;\
    \
    NSString *reuseIdentifier = nil;\
    if (NSStringEquals(kind, UICollectionElementKindSectionHeader)) {\
        reuseIdentifier = interfaceSection.headerReuseIdentifier;\
    } else if (NSStringEquals(kind, UICollectionElementKindSectionFooter)) {\
        reuseIdentifier = interfaceSection.footerReuseIdentifier;\
    }\
    if (reuseIdentifier != nil) {\
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];\
    } else {\
        view = [[UICollectionReusableView alloc] init];\
    }\
    \
    /* set the delegate if possible */ \
    if ([view conformsToProtocol:@protocol(IDLActionResponseSource)]) {\
        [(id<IDLActionResponseSource>)view setActionResponseDelegate:self];\
    }\
    \
    [self populateSupplementaryView:view ofKind:kind withSection:interfaceSection atIndexPath:indexPath forCollectionView:collectionView forDisplay:NO];\
    \
    /* update the layout */ \
    [view setNeedsLayout];\
    \
    return view;\
}

#pragma mark - UICollectionViewDelegateFlowLayout -

#define kViewStoreSizeCaller @"size"

// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section

#define IDL_POPULATABLE_CollectionViewController_referenceSizeForHeaderInSection() \
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section\
{\
    IDLInterfaceDataSource *dataSource = [self interfaceDataSourceForView:collectionView];\
    IDLInterfaceSection *interfaceSection = [dataSource sectionAtIndex:section];\
    \
    if (!interfaceSection.headerDimensions) {\
        CGSize size = CGSizeMake(0.0f, 0.0f);\
        IDLInterfaceDimensions *registeredDimensions = [dataSource registeredDimensionsForSectionHeaderReuseIdentifier:interfaceSection.headerReuseIdentifier];\
        if (registeredDimensions != nil) {\
            size = registeredDimensions.size;\
        } else {\
            if (interfaceSection.headerReuseIdentifier != nil) {\
                BOOL success = NO;\
                if ([self respondsToSelector:@selector(calculatedSizeForSupplementaryViewOfKind:withSection:forCollectionView:success:)]) {\
                    size = [self calculatedSizeForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withSection:interfaceSection forCollectionView:collectionView success:&success];\
                }\
                if (!success) {\
                    IDLCollectionReusableView *view = (IDLCollectionReusableView *)[self.viewStore platformSubclassInstanceWithReuseIdentifier:interfaceSection.headerReuseIdentifier caller:kViewStoreSizeCaller];\
                    if (view != nil) {\
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];\
                        [self populateSupplementaryView:view ofKind:UICollectionElementKindSectionHeader withSection:interfaceSection atIndexPath:indexPath forCollectionView:collectionView forDisplay:NO];\
                        size = view.calculatedSize;\
                    }\
                }\
            }\
        }\
        interfaceSection.headerDimensions = [IDLInterfaceDimensions dimensionsWithSize:size];\
    }\
    return interfaceSection.headerDimensions.size;\
}

// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section

#define IDL_POPULATABLE_CollectionViewController_referenceSizeForFooterInSection() \
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section\
{\
    IDLInterfaceDataSource *dataSource = [self interfaceDataSourceForView:collectionView];\
    IDLInterfaceSection *interfaceSection = [dataSource sectionAtIndex:section];\
    \
    if (!interfaceSection.footerDimensions) {\
        CGSize size = CGSizeMake(0.0f, 0.0f);\
        IDLInterfaceDimensions *registeredDimensions = [dataSource registeredDimensionsForSectionFooterReuseIdentifier:interfaceSection.footerReuseIdentifier];\
        if (registeredDimensions != nil) {\
            size = registeredDimensions.size;\
        } else {\
            if (interfaceSection.footerReuseIdentifier != nil) {\
                BOOL success = NO;\
                if ([self respondsToSelector:@selector(calculatedSizeForSupplementaryViewOfKind:withSection:forCollectionView:success:)]) {\
                    size = [self calculatedSizeForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withSection:interfaceSection forCollectionView:collectionView success:&success];\
                }\
                if (!success) {\
                    IDLCollectionReusableView *view = (IDLCollectionReusableView *)[self.viewStore platformSubclassInstanceWithReuseIdentifier:interfaceSection.footerReuseIdentifier caller:kViewStoreSizeCaller];\
                    if (view != nil) {\
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];\
                        [self populateSupplementaryView:view ofKind:UICollectionElementKindSectionFooter withSection:interfaceSection atIndexPath:indexPath forCollectionView:collectionView forDisplay:NO];\
                        size = view.calculatedSize;\
                    }\
                }\
            }\
        }\
        interfaceSection.footerDimensions = [IDLInterfaceDimensions dimensionsWithSize:size];\
    }\
    return interfaceSection.footerDimensions.size;\
}

// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

#define IDL_POPULATABLE_CollectionViewController_sizeForItemAtIndexPath() \
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath\
{\
    IDLInterfaceDataSource *dataSource = [self interfaceDataSourceForView:collectionView];\
    IDLInterfaceItem *interfaceItem = [dataSource itemAtIndexPath:indexPath];\
    \
    if (!interfaceItem.dimensions) {\
        CGSize size = CGSizeMake(0.0f, 0.0f);\
        IDLInterfaceDimensions *registeredDimensions = [dataSource registeredDimensionsForItemReuseIdentifier:interfaceItem.reuseIdentifier];\
        if (registeredDimensions != nil) {\
            size = registeredDimensions.size;\
        } else {\
            if (interfaceItem.reuseIdentifier != nil) {\
                BOOL success = NO;\
                if ([self respondsToSelector:@selector(calculatedSizeForItemAtIndexPath:withItem:forCollectionView:success:)]) {\
                    size = [self calculatedSizeForItemAtIndexPath:indexPath withItem:interfaceItem forCollectionView:collectionView success:&success];\
                }\
                if (!success) {\
                    IDLCollectionViewCell *cell = (IDLCollectionViewCell *)[self.viewStore platformSubclassInstanceWithReuseIdentifier:interfaceItem.reuseIdentifier caller:kViewStoreSizeCaller];\
                    if (cell != nil) {\
                        [self populateCell:cell withItem:interfaceItem atIndexPath:indexPath forCollectionView:collectionView forDisplay:NO];\
                        size = cell.calculatedSize;\
                    }\
                }\
            }\
        }\
        interfaceItem.dimensions = [IDLInterfaceDimensions dimensionsWithSize:size];\
    }\
    return interfaceItem.dimensions.size;\
}

#pragma mark - UICollectionViewDelegate -

// - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

#define IDL_POPULATABLE_CollectionViewController_didSelectItemAtIndexPath() \
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath\
{\
    IDLInterfaceItem *interfaceItem = [[self interfaceDataSourceForView:collectionView] itemAtIndexPath:indexPath];\
    \
    if (!interfaceItem.ignoreSelection) {\
        NSObject<IDLViewControllerInterfaceItemSelectionDelegate> *responder = self;\
        \
        if ([self.interfaceItemSelectionDelegate respondsToSelector:@selector(interfaceItemSelected:atIndexPath:forView:forViewController:)]) {\
            responder = self.interfaceItemSelectionDelegate;\
        }\
        \
        [responder interfaceItemSelected:interfaceItem atIndexPath:indexPath forView:collectionView forViewController:self];\
        \
        if (interfaceItem.transitorySelection) {\
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];\
        }\
    } else {\
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];\
    }\
}

#pragma mark - Groupings -

// IDL_POPULATABLE_IDLPopulatableCollectionViewDelegate()

#define IDL_POPULATABLE_IDLPopulatableCollectionViewDelegate() \
\
IDL_POPULATABLE_IDLPopulatableCollectionViewDelegate_populateCell()\
\
IDL_POPULATABLE_IDLPopulatableCollectionViewDelegate_populateSupplementaryView()

// IDL_POPULATABLE_CollectionViewController_UICollectionViewDatasource()

#define IDL_POPULATABLE_CollectionViewController_UICollectionViewDatasource() \
\
IDL_POPULATABLE_CollectionViewController_numberOfItemsInSection()\
\
IDL_POPULATABLE_CollectionViewController_numberOfSectionsInCollectionView()\
\
IDL_POPULATABLE_CollectionViewController_cellForItemAtIndexPath()\
\
IDL_POPULATABLE_CollectionViewController_viewForSupplementaryElementOfKind()

// IDL_POPULATABLE_CollectionViewController_UICollectionViewDelegateFlowLayout()

#define IDL_POPULATABLE_CollectionViewController_UICollectionViewDelegateFlowLayout() \
\
IDL_POPULATABLE_CollectionViewController_referenceSizeForHeaderInSection()\
\
IDL_POPULATABLE_CollectionViewController_referenceSizeForFooterInSection()\
\
IDL_POPULATABLE_CollectionViewController_sizeForItemAtIndexPath()

// IDL_POPULATABLE_CollectionViewController_UICollectionViewDelegate()

#define IDL_POPULATABLE_CollectionViewController_UICollectionViewDelegate()\
\
IDL_POPULATABLE_CollectionViewController_didSelectItemAtIndexPath()

// IDL_POPULATABLE_CollectionViewController_ALL

#define IDL_POPULATABLE_CollectionViewController_ALL \
\
IDL_POPULATABLE_CollectionViewController_UICollectionViewDatasource()\
\
IDL_POPULATABLE_CollectionViewController_UICollectionViewDelegateFlowLayout()\
\
IDL_POPULATABLE_CollectionViewController_UICollectionViewDelegate()

#endif
