//
//  IDLInterfaceSection.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 5/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceItem.h"

@interface IDLInterfaceSection : IDLInterfaceElement

@property (nonatomic, strong) Class itemClass;

@property (readonly) NSUInteger count;
@property (nonatomic, strong, readonly) NSArray *items;

@property (nonatomic, strong) NSString *indexTitle;
@property (nonatomic, strong) NSString *headerReuseIdentifier;
@property (nonatomic, strong) NSString *footerReuseIdentifier;
@property (nonatomic, strong) NSString *headerPopulatableAssistantIdentifier;
@property (nonatomic, strong) NSString *footerPopulatableAssistantIdentifier;

@property (nonatomic, strong) IDLInterfaceDimensions *headerDimensions;
@property (nonatomic, strong) IDLInterfaceDimensions *footerDimensions;

@property (nonatomic, assign) UIEdgeInsets sectionInsets;
@property (nonatomic, assign) BOOL generatedBySplit;

@property (readonly) IDLInterfaceItem *firstItem;
@property (readonly) IDLInterfaceItem *lastItem;


+(id)sectionWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle;
+(id)sectionWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle headerReuseIdentifier:(NSString *)reuseIdentifier;
-(id)initWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle headerReuseIdentifier:(NSString *)reuseIdentifier;

-(void)addItem:(IDLInterfaceItem *)item;
-(void)insertItem:(IDLInterfaceItem *)item atIndex:(NSInteger)index;
-(void)addItems:(NSArray *)items;
-(void)removeItem:(IDLInterfaceItem *)item;
-(void)removeAllItems;
-(NSInteger)indexOfItem:(IDLInterfaceItem *)item;
-(NSInteger)firstIndexOfItemWithReuseIdentifier:(NSString *)reuseIdentifier;
-(NSInteger)nextIndexOfItemWithReuseIdentifier:(NSString *)reuseIdentifier afterIndex:(NSInteger)index;

-(BOOL)isEqualToTitle:(NSString *)title indexTitle:(NSString *)indexTitle;
-(IDLInterfaceItem *)itemAtIndex:(NSUInteger)index;

-(IDLInterfaceItem *)newItem;
-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier;
-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier ignoreSelection:(BOOL)ignoreSelection;
-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier ignoreSelection:(BOOL)ignoreSelection insertAtIndex:(NSInteger)index;
-(IDLInterfaceItem *)newItemWithHeight:(CGFloat)height;
-(IDLInterfaceItem *)newItemWithSize:(CGSize)size;
-(IDLInterfaceItem *)newItemWithHeight:(CGFloat)height ignoreSelection:(BOOL)ignoreSelection;
-(IDLInterfaceItem *)newItemWithSize:(CGSize)size ignoreSelection:(BOOL)ignoreSelection;
-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier dimensions:(IDLInterfaceDimensions *)dimensions;
-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier dimensions:(IDLInterfaceDimensions *)dimensions ignoreSelection:(BOOL)ignoreSelection;
-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier dimensions:(IDLInterfaceDimensions *)dimensions alternatingFlag:(IDLInterfaceAlternatingFlag)flag;
-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier dimensions:(IDLInterfaceDimensions *)dimensions ignoreSelection:(BOOL)ignoreSelection alternatingFlag:(IDLInterfaceAlternatingFlag)flag;

-(NSArray *)itemIndexPathsRequiringReload:(NSUInteger)sectionIndex;

-(void)updateInterfaceItemPositions;
-(void)setItemsRequireReload:(BOOL)requireReload;

-(NSIndexSet *)itemIndexesWithReuseIdentifier:(NSString *)reuseIdentifier;

-(NSSet *)itemReuseIdentifiers;

@end
