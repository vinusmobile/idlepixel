//
//  UICollectionView+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UICollectionView+Idlepixel.h"
#import "UINib+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "NSBundle+Idlepixel.h"
#import "UIScrollView+Idlepixel.h"

@implementation UICollectionView (IDLPlatform)

-(void)registerPlatformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass
{
    [self registerPlatformReuseIdentifiableCellClassNib:reuseIdentifiableCellClass bundle:[NSBundle mainBundle]];
}

-(void)registerPlatformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass bundle:(NSBundle *)bundle
{
    if ([reuseIdentifiableCellClass conformsToProtocol:@protocol(IDLReuseIdentifiable)]) {
        if (![self platformReuseIdentifiableCellClassNib:reuseIdentifiableCellClass registeredFromBundle:bundle type:@"cell"]) {
            [self registerPlatformClassNib:reuseIdentifiableCellClass forCellWithReuseIdentifier:[reuseIdentifiableCellClass reuseIdentifier] bundle:bundle];
        //} else {
        //IDLLogContext(@"already registered: %@",reuseIdentifiableCellClass);
        }
    }
}

-(void)registerPlatformReuseIdentifiableViewClassNib:(Class)reuseIdentifiableViewClass forSupplementaryViewOfKind:(NSString *)elementKind
{
    [self registerPlatformReuseIdentifiableViewClassNib:reuseIdentifiableViewClass forSupplementaryViewOfKind:elementKind bundle:[NSBundle mainBundle]];
}

-(void)registerPlatformReuseIdentifiableViewClassNib:(Class)reuseIdentifiableViewClass forSupplementaryViewOfKind:(NSString *)elementKind bundle:(NSBundle *)bundle
{
    if ([reuseIdentifiableViewClass conformsToProtocol:@protocol(IDLReuseIdentifiable)]) {
        if (![self platformReuseIdentifiableCellClassNib:reuseIdentifiableViewClass registeredFromBundle:bundle type:elementKind]) {
            [self registerPlatformClassNib:reuseIdentifiableViewClass forSupplementaryViewOfKind:elementKind withReuseIdentifier:[reuseIdentifiableViewClass reuseIdentifier] bundle:bundle];
        //} else {
        //IDLLogContext(@"already registered: %@",reuseIdentifiableViewClass);
        }
    }
}

-(void)registerPlatformClassNib:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self registerPlatformClassNib:cellClass forCellWithReuseIdentifier:identifier bundle:[NSBundle mainBundle]];
}

-(void)registerPlatformClassNib:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    UINib *nib = [UINib platformNibForClass:cellClass bundle:bundle];
    if (nib) [self registerNib:nib forCellWithReuseIdentifier:identifier];
}

-(void)registerPlatformClassNib:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier
{
    [self registerPlatformClassNib:viewClass forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier bundle:[NSBundle mainBundle]];
}

-(void)registerPlatformClassNib:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    UINib *nib = [UINib platformNibForClass:viewClass bundle:bundle];
    if (nib) [self registerNib:nib forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
}

@end

