//
//  IDLTabBar.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/09/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLLabel.h"
#import "IDLView.h"

@interface IDLTabBarItemView : IDLView

@property (nonatomic, weak) IDLLabel *titleLabel;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL enabled;

@end

@class IDLTabBar;

@protocol IDLTabBarDelegate<NSObject>
@optional

- (void)tabBar:(IDLTabBar *)tabBar didSelectItem:(UITabBarItem *)item;

@end

typedef void(^IDLTabBarCustomizationBlock)(IDLTabBarItemView *tabBarItemView, UITabBarItem *tabBarItem);

@interface IDLTabBar : IDLView

@property (nonatomic, assign) id<IDLTabBarDelegate> delegate;
@property (nonatomic, copy)   NSArray *items;
@property (nonatomic, weak) UITabBarItem *selectedItem;
@property (readwrite) NSInteger selectedIndex;

@property (readonly) NSInteger lastSelectedIndex;
@property (nonatomic, strong, readonly) NSArray *selectedIndexHistory;

-(void)setSelectedItem:(UITabBarItem *)selectedItem notifyDelegate:(BOOL)notifyDelegate;
-(void)setSelectedIndex:(NSInteger)selectedIndex notifyDelegate:(BOOL)notifyDelegate;

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat contentSpacing;
@property (nonatomic, assign) CGFloat maximumItemWidth;
@property (readonly) CGSize itemSize;

@property (nonatomic, assign) Class tabBarItemViewClass;

@property (nonatomic, copy) IDLTabBarCustomizationBlock customizationBlock;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) UIImage *overlayImage;
@property (nonatomic, strong) UIImage *selectionIndicatorImage;

@end
