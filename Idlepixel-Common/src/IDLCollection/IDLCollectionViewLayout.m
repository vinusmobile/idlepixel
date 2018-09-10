//
//  IDLCollectionViewLayout.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLCollectionViewLayout.h"
#import "UICollectionViewLayout+Idlepixel.h"

@implementation IDLCollectionViewLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    if (self.collectionStyle == IDLCollectionViewStyleGrouped) {
        return [self stickyHeaderLayoutAttributesForElementsInRect:rect attributes:[super layoutAttributesForElementsInRect:rect]];
    } else {
        return [super layoutAttributesForElementsInRect:rect];
    }
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    if (self.collectionStyle == IDLCollectionViewStyleGrouped) {
        return YES;
    } else {
        return [super shouldInvalidateLayoutForBoundsChange:newBound];
    }
}

@end

@implementation IDLCollectionViewFlowLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    if (self.collectionStyle == IDLCollectionViewStyleGrouped) {
        return [self stickyHeaderLayoutAttributesForElementsInRect:rect attributes:[super layoutAttributesForElementsInRect:rect]];
    } else {
        return [super layoutAttributesForElementsInRect:rect];
    }
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    if (self.collectionStyle == IDLCollectionViewStyleGrouped) {
        return YES;
    } else {
        return [super shouldInvalidateLayoutForBoundsChange:newBound];
    }
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];
    NSMutableArray *removedIndexPaths = [NSMutableArray array];
    NSMutableArray *insertedSectionIndices = [NSMutableArray array];
    NSMutableArray *removedSectionIndices = [NSMutableArray array];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            if (updateItem.indexPathAfterUpdate.item == NSNotFound) {
                [insertedSectionIndices addObject:@(updateItem.indexPathAfterUpdate.section)];
            } else {
                [insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
            }
        } else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            if (updateItem.indexPathBeforeUpdate.item == NSNotFound) {
                [removedSectionIndices addObject:@(updateItem.indexPathBeforeUpdate.section)];
            } else {
                [removedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
            }
        }
    }];
    self.insertedIndexPaths = [NSArray arrayWithArray:insertedIndexPaths];
    self.removedIndexPaths = [NSArray arrayWithArray:removedIndexPaths];
    self.insertedSectionIndices = [NSArray arrayWithArray:insertedSectionIndices];
    self.removedSectionIndices = [NSArray arrayWithArray:removedSectionIndices];
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    
    self.insertedIndexPaths     = nil;
    self.removedIndexPaths      = nil;
    self.insertedSectionIndices = nil;
    self.removedSectionIndices  = nil;
}

- (void)subtleAnimationAttributes:(UICollectionViewLayoutAttributes *)attributes present:(BOOL)present
{
    if (present) {
        attributes.zIndex = 0;
        CATransform3D transform3D = CATransform3DMakeScale(1.0f, 0.1f, 1.0f);
        //transform3D = CATransform3DTranslate(transform3D, 0.0f, attributes.size.height, 0.0f);
        attributes.transform3D = transform3D;
        //attributes.alpha = 1.0f;
    } else {
        attributes.zIndex = 1;
    }
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if (self.animationStyle == IDLCollectionViewLayoutAnimationStyleSubtle) {
        [self subtleAnimationAttributes:attributes present:[self.insertedIndexPaths containsObject:itemIndexPath]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if (self.animationStyle == IDLCollectionViewLayoutAnimationStyleSubtle) {
        [self subtleAnimationAttributes:attributes present:[self.removedIndexPaths containsObject:itemIndexPath]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    if (self.animationStyle == IDLCollectionViewLayoutAnimationStyleSubtle) {
        [self subtleAnimationAttributes:attributes present:[self.insertedIndexPaths containsObject:elementIndexPath]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    if (self.animationStyle == IDLCollectionViewLayoutAnimationStyleSubtle) {
        [self subtleAnimationAttributes:attributes present:[self.removedIndexPaths containsObject:elementIndexPath]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
    if (self.animationStyle == IDLCollectionViewLayoutAnimationStyleSubtle) {
        [self subtleAnimationAttributes:attributes present:[self.insertedIndexPaths containsObject:decorationIndexPath]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
    if (self.animationStyle == IDLCollectionViewLayoutAnimationStyleSubtle) {
        [self subtleAnimationAttributes:attributes present:[self.removedIndexPaths containsObject:decorationIndexPath]];
    }
    return attributes;
}

@end
