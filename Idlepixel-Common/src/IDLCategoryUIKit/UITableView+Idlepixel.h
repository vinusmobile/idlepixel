//
//  UITableView+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 9/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView  (IDLPlatform)

-(void)registerPlatformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass;
-(void)registerPlatformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass bundle:(NSBundle *)bundle;

-(void)registerPlatformReuseIdentifiableViewClassNib:(Class)reuseIdentifiableViewClass;
-(void)registerPlatformReuseIdentifiableViewClassNib:(Class)reuseIdentifiableViewClass bundle:(NSBundle *)bundle;

-(void)registerPlatformClassNib:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
-(void)registerPlatformClassNib:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle;

-(void)registerPlatformClassNib:(Class)viewClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier;
-(void)registerPlatformClassNib:(Class)viewClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle;

@end

@interface UITableView (IDLHiddenSeparators)

-(void)hideEmptySeparators;

@end

@interface UITableView (IDLSearchResultTableView)

@property (readonly) BOOL isSearchResultsTableView;

@end

@interface UITableView (IDLTableViewIndex)

-(UIView *)tableViewIndex;
-(CGFloat)tableViewMaximumCellWidth;

@end
