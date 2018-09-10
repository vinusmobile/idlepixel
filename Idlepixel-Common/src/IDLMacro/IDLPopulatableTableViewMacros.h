//
//  IDLPopulatableTableViewMacros.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 26/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLPopulatableMacros.h"

#ifndef Idlepixel_Common_IDLPopulatableTableViewMacros_h
#define Idlepixel_Common_IDLPopulatableTableViewMacros_h

#pragma mark - IDLPopulatableTableViewDelegate -

// -(BOOL)populateCell:(UITableViewCell *)cell withItem:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay

#define IDL_POPULATABLE_IDLPopulatableTableViewDelegate_populateCell() \
-(BOOL)populateCell:(UITableViewCell *)cell withItem:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay\
{\
    BOOL populated = NO;\
    id<IDLPopulatableTableViewAssistant> assistant = [[IDLPopulatableViewAssistantManager sharedManager] tableViewAssistantForInterfaceItem:interfaceItem viewController:self];\
    if (assistant != nil) {\
        populated = [assistant populateCell:cell withItem:interfaceItem atIndexPath:indexPath forTableView:tableView forDisplay:forDisplay];\
    }\
    return populated;\
}

// -(BOOL)populateHeaderView:(UITableViewHeaderFooterView *)view withSection:(IDLInterfaceSection *)interfaceSection section:(NSInteger)section forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay

#define IDL_POPULATABLE_IDLPopulatableTableViewDelegate_populateHeaderView() \
-(BOOL)populateHeaderView:(UITableViewHeaderFooterView *)view withSection:(IDLInterfaceSection *)interfaceSection section:(NSInteger)section forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay\
{\
    BOOL populated = NO;\
    id<IDLPopulatableTableViewAssistant> assistant = [self.populatableAssistantManager tableViewAssistantForInterfaceSectionHeader:interfaceSection viewController:self];\
    if (assistant != nil) {\
        populated = [assistant populateHeaderView:view withSection:interfaceSection section:section forTableView:tableView forDisplay:forDisplay];\
    }\
    return populated;\
}

// -(BOOL)populateFooterView:(UITableViewHeaderFooterView *)view withSection:(IDLInterfaceSection *)interfaceSection section:(NSInteger)section forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay

#define IDL_POPULATABLE_IDLPopulatableTableViewDelegate_populateFooterView() \
-(BOOL)populateFooterView:(UITableViewHeaderFooterView *)view withSection:(IDLInterfaceSection *)interfaceSection section:(NSInteger)section forTableView:(UITableView *)tableView forDisplay:(BOOL)forDisplay\
{\
    BOOL populated = NO;\
    id<IDLPopulatableTableViewAssistant> assistant = [self.populatableAssistantManager tableViewAssistantForInterfaceSectionFooter:interfaceSection viewController:self];\
    if (assistant != nil) {\
        populated = [assistant populateFooterView:view withSection:interfaceSection section:section forTableView:tableView forDisplay:forDisplay];\
    }\
    return populated;\
}

#pragma mark - UITableViewDatasource -

// - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

#define IDL_POPULATABLE_TableViewController_numberOfRowsInSection() \
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section \
{\
    return [[self interfaceDataSourceForView:tableView] numberOfItemsInSection:section];\
}

// - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

#define IDL_POPULATABLE_TableViewController_numberOfSectionsInTableView() \
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView \
{\
    return [self interfaceDataSourceForView:tableView].sectionCount;\
}

#define kViewStoreHeightCaller @"height"

// - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

#define IDL_POPULATABLE_TableViewController_heightForHeaderInSection() \
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section\
{\
    IDLInterfaceDataSource *dataSource = [self interfaceDataSourceForView:tableView];\
    IDLInterfaceSection *interfaceSection = [dataSource sectionAtIndex:section];\
    \
    if (!interfaceSection.headerDimensions) {\
        CGFloat height = 0.0f;\
        IDLInterfaceDimensions *registeredDimensions = [dataSource registeredDimensionsForSectionHeaderReuseIdentifier:interfaceSection.headerReuseIdentifier];\
        if (registeredDimensions != nil) {\
            height = registeredDimensions.height;\
        } else {\
            if (interfaceSection.headerReuseIdentifier != nil) {\
                IDLTableViewHeaderFooterView *view = (IDLTableViewHeaderFooterView *)[self.viewStore platformSubclassInstanceWithReuseIdentifier:interfaceSection.headerReuseIdentifier caller:kViewStoreHeightCaller];\
                if (view == nil) {\
                    view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:interfaceSection.headerReuseIdentifier];\
                    if (view != nil) [self.viewStore storeView:view withReuseIdentifier:interfaceSection.headerReuseIdentifier caller:kViewStoreHeightCaller];\
                }\
                [self populateHeaderView:view withSection:interfaceSection section:section forTableView:tableView forDisplay:NO];\
                height = view.calculatedHeight;\
            }\
        }\
        interfaceSection.headerDimensions = [IDLInterfaceDimensions dimensionsWithHeight:height];\
    }\
    return interfaceSection.headerDimensions.height;\
}

// - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

#define IDL_POPULATABLE_TableViewController_heightForFooterInSection() \
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section \
{\
    IDLInterfaceDataSource *dataSource = [self interfaceDataSourceForView:tableView];\
    IDLInterfaceSection *interfaceSection = [dataSource sectionAtIndex:section];\
    \
    if (!interfaceSection.footerDimensions) {\
        CGFloat height = 0.0f;\
        IDLInterfaceDimensions *registeredDimensions = [dataSource registeredDimensionsForSectionFooterReuseIdentifier:interfaceSection.footerReuseIdentifier];\
        if (registeredDimensions != nil) {\
            height = registeredDimensions.height;\
        } else {\
            if (interfaceSection.footerReuseIdentifier != nil) {\
                IDLTableViewHeaderFooterView *view = (IDLTableViewHeaderFooterView *)[self.viewStore platformSubclassInstanceWithReuseIdentifier:interfaceSection.footerReuseIdentifier caller:kViewStoreHeightCaller];\
                if (view == nil) {\
                    view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:interfaceSection.footerReuseIdentifier];\
                    if (view != nil) [self.viewStore storeView:view withReuseIdentifier:interfaceSection.footerReuseIdentifier caller:kViewStoreHeightCaller];\
                }\
                [self populateFooterView:view withSection:interfaceSection section:section forTableView:tableView forDisplay:NO];\
                height = view.calculatedHeight;\
            }\
        }\
        interfaceSection.footerDimensions = [IDLInterfaceDimensions dimensionsWithHeight:height];\
    }\
    return interfaceSection.footerDimensions.height;\
}

// - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

#define IDL_POPULATABLE_TableViewController_heightForRowAtIndexPath() \
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath\
{\
    IDLInterfaceDataSource *dataSource = [self interfaceDataSourceForView:tableView];\
    IDLInterfaceItem *interfaceItem = [dataSource itemAtIndexPath:indexPath];\
    \
    if (!interfaceItem.dimensions) {\
    \
        CGFloat height = 0.0f;\
        IDLInterfaceDimensions *registeredDimensions = [dataSource registeredDimensionsForItemReuseIdentifier:interfaceItem.reuseIdentifier];\
        if (registeredDimensions != nil) {\
            height = registeredDimensions.height;\
        } else {\
            if (interfaceItem.reuseIdentifier != nil) {\
                IDLTableViewCell *cell = (IDLTableViewCell *)[self.viewStore platformSubclassInstanceWithReuseIdentifier:interfaceItem.reuseIdentifier caller:kViewStoreHeightCaller];\
                if (cell == nil) {\
                    cell = [tableView dequeueReusableCellWithIdentifier:interfaceItem.reuseIdentifier];\
                    if (cell != nil) [self.viewStore storeView:cell withReuseIdentifier:interfaceItem.reuseIdentifier caller:kViewStoreHeightCaller];\
                }\
                [self populateCell:cell withItem:interfaceItem atIndexPath:indexPath forTableView:tableView forDisplay:NO];\
                height = cell.calculatedHeight;\
            }\
        }\
        interfaceItem.dimensions = [IDLInterfaceDimensions dimensionsWithHeight:height];\
    }\
    return interfaceItem.dimensions.height;\
}

// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

#define IDL_POPULATABLE_TableViewController_cellForRowAtIndexPath() \
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath\
{\
    /* Get the relevant item */ \
    IDLInterfaceItem *item = [[self interfaceDataSourceForView:tableView] itemAtIndexPath:indexPath];\
    UITableViewCell *cell = nil;\
    \
    if (item.reuseIdentifier != nil) {\
        cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier forIndexPath:indexPath];\
    } else {\
        cell = [[UITableViewCell alloc] init];\
    }\
    cell.indexPath = indexPath;\
    \
    if (item.ignoreSelection) {\
        cell.selectionStyle = UITableViewCellSelectionStyleNone;\
    } else {\
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;\
    }\
    \
    /* set the delegate if possible */ \
    if ([cell conformsToProtocol:@protocol(IDLActionResponseSource)]) {\
        [(id<IDLActionResponseSource>)cell setActionResponseDelegate:self];\
    }\
    \
    /* populate the cell */ \
    [self populateCell:cell withItem:item atIndexPath:indexPath forTableView:tableView forDisplay:YES];\
    \
    /* update the layout */ \
    [cell setNeedsLayout];\
    \
    /* Return the cell */ \
    return cell;\
}

// - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

#define IDL_POPULATABLE_TableViewController_viewForHeaderInSection() \
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section\
{\
    IDLInterfaceSection *interfaceSection = [[self interfaceDataSourceForView:tableView] sectionAtIndex:section];\
    UITableViewHeaderFooterView *view = nil;\
    \
    if (interfaceSection.headerReuseIdentifier != nil) {\
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:interfaceSection.headerReuseIdentifier];\
    } else {\
        view = [[UITableViewHeaderFooterView alloc] init];\
        view.backgroundView = [UIView viewWithFrame:view.bounds backgroundColor:[UIColor clearColor]];\
    }\
    \
    /* set the delegate if possible */ \
    if ([view conformsToProtocol:@protocol(IDLActionResponseSource)]) {\
        [(id<IDLActionResponseSource>)view setActionResponseDelegate:self];\
    }\
    \
    [self populateHeaderView:view withSection:interfaceSection section:section forTableView:tableView forDisplay:YES];\
    \
    /* update the layout */ \
    [view setNeedsLayout];\
    \
    return view;\
}

// - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

#define IDL_POPULATABLE_TableViewController_viewForFooterInSection() \
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section\
{\
    IDLInterfaceSection *interfaceSection = [[self interfaceDataSourceForView:tableView] sectionAtIndex:section];\
    UITableViewHeaderFooterView *view = nil;\
    \
    if (interfaceSection.footerReuseIdentifier != nil) {\
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:interfaceSection.footerReuseIdentifier];\
    } else {\
        view = [[UITableViewHeaderFooterView alloc] init];\
        view.backgroundView = [UIView viewWithFrame:view.bounds backgroundColor:[UIColor clearColor]];\
    }\
    \
    /* set the delegate if possible */ \
    if ([view conformsToProtocol:@protocol(IDLActionResponseSource)]) {\
        [(id<IDLActionResponseSource>)view setActionResponseDelegate:self];\
    }\
    \
    [self populateFooterView:view withSection:interfaceSection section:section forTableView:tableView forDisplay:YES];\
    \
    /* update the layout */ \
    [view setNeedsLayout];\
    \
    return view;\
}

#pragma mark - UITableViewDelegate -

// -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

#define IDL_POPULATABLE_TableViewController_didSelectRowAtIndexPath() \
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath\
{\
    IDLInterfaceItem *interfaceItem = [[self interfaceDataSourceForView:tableView] itemAtIndexPath:indexPath];\
    if (!interfaceItem.ignoreSelection) {\
        \
        NSObject<IDLViewControllerInterfaceItemSelectionDelegate> *responder = self;\
        \
        if ([self.interfaceItemSelectionDelegate respondsToSelector:@selector(interfaceItemSelected:atIndexPath:forView:forViewController:)]) {\
            responder = self.interfaceItemSelectionDelegate;\
        }\
        \
        [responder interfaceItemSelected:interfaceItem atIndexPath:indexPath forView:tableView forViewController:self];\
        \
        if (interfaceItem.transitorySelection) {\
            [tableView deselectRowAtIndexPath:indexPath animated:NO];\
        }\
    } else {\
        [tableView deselectRowAtIndexPath:indexPath animated:YES];\
    }\
}

#pragma mark - Groupings -

// IDL_POPULATABLE_IDLPopulatableTableViewDelegate()

#define IDL_POPULATABLE_IDLPopulatableTableViewDelegate() \
\
IDL_POPULATABLE_IDLPopulatableTableViewDelegate_populateCell()\
\
IDL_POPULATABLE_IDLPopulatableTableViewDelegate_populateHeaderView()\
\
IDL_POPULATABLE_IDLPopulatableTableViewDelegate_populateFooterView()

// IDL_POPULATABLE_TableViewController_UITableViewDatasource()

#define IDL_POPULATABLE_TableViewController_UITableViewDatasource() \
\
IDL_POPULATABLE_TableViewController_numberOfRowsInSection()\
\
IDL_POPULATABLE_TableViewController_numberOfSectionsInTableView()\
\
IDL_POPULATABLE_TableViewController_heightForHeaderInSection()\
\
IDL_POPULATABLE_TableViewController_heightForFooterInSection()\
\
IDL_POPULATABLE_TableViewController_heightForRowAtIndexPath()\
\
IDL_POPULATABLE_TableViewController_cellForRowAtIndexPath()\
\
IDL_POPULATABLE_TableViewController_viewForHeaderInSection()\
\
IDL_POPULATABLE_TableViewController_viewForFooterInSection()

// IDL_POPULATABLE_TableViewController_UITableViewDelegate()

#define IDL_POPULATABLE_TableViewController_UITableViewDelegate()\
\
IDL_POPULATABLE_TableViewController_didSelectRowAtIndexPath()

// IDL_POPULATABLE_TableViewController_ALL

#define IDL_POPULATABLE_TableViewController_ALL \
\
IDL_POPULATABLE_TableViewController_UITableViewDatasource()\
\
IDL_POPULATABLE_TableViewController_UITableViewDelegate()

#endif
