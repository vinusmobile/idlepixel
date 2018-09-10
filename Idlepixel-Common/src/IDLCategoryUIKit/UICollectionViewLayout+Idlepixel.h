//
//  UICollectionViewLayout+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewLayout (StickyHeaders)

- (NSArray *) stickyHeaderLayoutAttributesForElementsInRect:(CGRect)rect attributes:(NSArray *)attributes;

@end
