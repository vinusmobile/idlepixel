//
//  UITableView+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 9/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UITableView+Idlepixel.h"
#import "UINib+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "NSBundle+Idlepixel.h"
#import "IDLInterfaceProtocols.h"
#import "NSArray+Idlepixel.h"
#import "NSString+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"
#import "IDLMacroHeaders.h"

#import "UIScrollView+Idlepixel.h"

@implementation UITableView (IDLPlatform)

-(void)registerPlatformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass
{
    [self registerPlatformReuseIdentifiableCellClassNib:reuseIdentifiableCellClass bundle:[NSBundle mainBundle]];
}

-(void)registerPlatformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass bundle:(NSBundle *)bundle
{
    if ([reuseIdentifiableCellClass conformsToProtocol:@protocol(IDLReuseIdentifiable)]) {
        if (![self platformReuseIdentifiableCellClassNib:reuseIdentifiableCellClass registeredFromBundle:bundle type:@"cell"]) {
            [self registerPlatformClassNib:reuseIdentifiableCellClass forCellReuseIdentifier:[reuseIdentifiableCellClass reuseIdentifier] bundle:bundle];
        //} else {
        //    IDLLogContext(@"already registered: %@",reuseIdentifiableCellClass);
        }
    }
}

-(void)registerPlatformReuseIdentifiableViewClassNib:(Class)reuseIdentifiableViewClass
{
    [self registerPlatformReuseIdentifiableViewClassNib:reuseIdentifiableViewClass bundle:[NSBundle mainBundle]];
}

-(void)registerPlatformReuseIdentifiableViewClassNib:(Class)reuseIdentifiableViewClass bundle:(NSBundle *)bundle
{
    if ([reuseIdentifiableViewClass conformsToProtocol:@protocol(IDLReuseIdentifiable)]) {
        if (![self platformReuseIdentifiableCellClassNib:reuseIdentifiableViewClass registeredFromBundle:bundle type:@"hf"]) {
            [self registerPlatformClassNib:reuseIdentifiableViewClass forHeaderFooterViewReuseIdentifier:[reuseIdentifiableViewClass reuseIdentifier] bundle:bundle];
        //} else {
        //    IDLLogContext(@"already registered: %@",reuseIdentifiableViewClass);
        }
    }
}

-(void)registerPlatformClassNib:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self registerPlatformClassNib:cellClass forCellReuseIdentifier:identifier bundle:[NSBundle mainBundle]];
}

-(void)registerPlatformClassNib:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    UINib *nib = [UINib platformNibForClass:cellClass bundle:bundle];
    if (nib) [self registerNib:nib forCellReuseIdentifier:identifier];
}

-(void)registerPlatformClassNib:(Class)viewClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier
{
    [self registerPlatformClassNib:viewClass forHeaderFooterViewReuseIdentifier:identifier bundle:[NSBundle mainBundle]];
}

-(void)registerPlatformClassNib:(Class)viewClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    UINib *nib = [UINib platformNibForClass:viewClass bundle:bundle];
    if (nib) [self registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
}

@end

@implementation UITableView (IDLHiddenSeparators)

- (void)hideEmptySeparators
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    self.tableFooterView = v;
}

@end

@implementation UITableView (IDLSearchResultTableView)

-(BOOL)isSearchResultsTableView
{
    return [self.className containsCaseInsensitiveString:@"searchresults"];
}

@end

@implementation UITableView (IDLTableViewIndex)

#define kTableViewIndexClassName    @"TableViewIndex"

-(UIView *)tableViewIndex
{
    static Class tableViewIndexClass = nil;
    
    NSEnumerator *enumerator = self.subviews.reverseObjectEnumerator;
    UIView *subview = nil;
    
    while ((subview = enumerator.nextObject)) {
        if (tableViewIndexClass != nil) {
            if ([subview isKindOfClass:tableViewIndexClass]) {
                return subview;
            }
        } else {
            if ([subview.className containsString:kTableViewIndexClassName]) {
                if (![subview isKindOfClass:[UITableViewCell class]]) {
                    tableViewIndexClass = subview.class;
                    return subview;
                }
            }
        }
        if ([subview isKindOfClass:[UITableViewCell class]]) {
            break;
        }
    }
    return nil;
}

-(CGFloat)tableViewMaximumCellWidth
{
    UIView *index = self.tableViewIndex;
    if (index != nil) {
        return index.frame.origin.x;
    } else {
        return self.contentSize.width;
    }
}

@end
