//
//  IDLCollectionViewLayout.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IDLCollectionViewStyle) {
	IDLCollectionViewStylePlain = UITableViewStylePlain,
	IDLCollectionViewStyleGrouped = UITableViewStyleGrouped,
};

typedef NS_ENUM(NSUInteger, IDLCollectionViewLayoutAnimationStyle) {
	IDLCollectionViewLayoutAnimationStyleDefault,
    IDLCollectionViewLayoutAnimationStyleSubtle,
};

@interface IDLCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) IDLCollectionViewStyle collectionStyle;

@end

@interface IDLCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) IDLCollectionViewStyle collectionStyle;
@property (nonatomic, assign) IDLCollectionViewLayoutAnimationStyle animationStyle;

@property (nonatomic, strong) NSArray *insertedIndexPaths;
@property (nonatomic, strong) NSArray *removedIndexPaths;
@property (nonatomic, strong) NSArray *insertedSectionIndices;
@property (nonatomic, strong) NSArray *removedSectionIndices;

@end
