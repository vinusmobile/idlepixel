//
//  UICollectionView+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLInterfaceProtocols.h"

@interface UICollectionView (IDLPlatform)

-(void)registerPlatformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass;
-(void)registerPlatformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass bundle:(NSBundle *)bundle;

-(void)registerPlatformReuseIdentifiableViewClassNib:(Class)reuseIdentifiableViewClass forSupplementaryViewOfKind:(NSString *)elementKind;
-(void)registerPlatformReuseIdentifiableViewClassNib:(Class)reuseIdentifiableViewClass forSupplementaryViewOfKind:(NSString *)elementKind bundle:(NSBundle *)bundle;

-(void)registerPlatformClassNib:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
-(void)registerPlatformClassNib:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle;

-(void)registerPlatformClassNib:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;
-(void)registerPlatformClassNib:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle;

@end
