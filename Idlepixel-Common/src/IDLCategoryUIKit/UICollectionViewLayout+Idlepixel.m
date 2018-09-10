//
//  UICollectionViewLayout+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UICollectionViewLayout+Idlepixel.h"
#import "IDLCommonMacros.h"
#import "IDLNSInlineExtensions.h"

@implementation UICollectionViewLayout (StickyHeaders)

//*
// Sticky section headers adapted from:
// http://blog.radi.ws/post/32905838158/sticky-headers-for-uicollectionview-using
//*

- (NSArray *) stickyHeaderLayoutAttributesForElementsInRect:(CGRect)rect attributes:(NSArray *)attributes
{
    NSMutableArray *answer = [attributes mutableCopy];
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (NSStringEquals(layoutAttributes.representedElementKind, UICollectionElementKindSectionHeader)) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [answer addObject:layoutAttributes];
        
    }];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        
        if (NSStringEquals(layoutAttributes.representedElementKind, UICollectionElementKindSectionHeader)) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            
            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
            
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = RANGE(contentOffset.y, (CGRectGetMinY(firstCellAttrs.frame) - headerHeight),
                             (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight));
            
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
        }
    }
    return [NSArray arrayWithArray:answer];
}


@end
