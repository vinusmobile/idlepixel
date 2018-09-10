//
//  IDLTabBar.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/09/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLTabBar.h"
#import "IDLCategoryFoundationHeaders.h"
#import "IDLCategoryUIKitHeaders.h"
#import "IDLCGInlineExtensions.h"
#import "IDLTapGestureRecognizer.h"

@implementation IDLTabBarItemView

-(void)configure
{
    [super configure];
    
    if (self.iconImageView == nil) {
        UIImageView *imageView = [UIImageView viewWithFrame:CGRectZero backgroundColor:UIColorClear];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        self.iconImageView = imageView;
    }
    if (self.titleLabel == nil) {
        IDLLabel *label = [IDLLabel viewWithFrame:CGRectZero backgroundColor:UIColorClear];
        label.verticalAlignment = IDLVerticalAlignmentBottom;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:9.0f];
        label.textColor = UIColorWhite;
        [self addSubview:label];
        self.titleLabel = label;
    }
    CGRect frame = self.bounds;
    frame = CGRectInset(frame, 2.0f, 2.0f);
    self.titleLabel.frame = frame;
    
    frame.size.height = MIN(30.0f, frame.size.height);
    self.iconImageView.frame = frame;
}

-(void)setTitleTextAttributes:(NSDictionary *)textAttributes
{
    [self.titleLabel applyTextAttributes:textAttributes];
}

@end

@interface IDLTabBar ()

@property (nonatomic, weak) UIView *itemContainerView;
@property (nonatomic, weak) UIView *indicatorContainerView;
@property (nonatomic, weak) UIView *buttonContainerView;
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIImageView *shadowImageView;
@property (nonatomic, weak) UIImageView *overlayImageView;

@property (nonatomic, weak) UIImageView *selectedIndicatorImageView;

@property (nonatomic, strong, readwrite) NSArray *selectedIndexHistory;

@end

@implementation IDLTabBar

-(void)configure
{
    [super configure];
    
    self.contentInsets = UIEdgeInsetsZero;
    self.contentSpacing = 0.0f;
    self.maximumItemWidth = 0.0f;
}

-(void)layoutContainerViews
{
    if (self.backgroundImageView == nil) {
        UIImageView *view = [UIImageView viewWithFrame:self.bounds backgroundColor:UIColorClear];
        view.contentMode = UIViewContentModeScaleToFill;
        view.image = self.backgroundImage;
        view.userInteractionEnabled = YES;
        [self addSubview:view];
        self.backgroundImageView = view;
    }
    if (self.shadowImageView == nil) {
        UIImageView *view = [UIImageView viewWithFrame:self.bounds backgroundColor:UIColorClear];
        view.contentMode = UIViewContentModeScaleToFill;
        view.image = self.shadowImage;
        view.userInteractionEnabled = NO;
        [self addSubview:view];
        self.shadowImageView = view;
    }
    if (self.indicatorContainerView == nil) {
        UIView *view = [UIView viewWithFrame:self.bounds backgroundColor:UIColorClear];
        view.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:view];
        self.indicatorContainerView = view;
    }
    if (self.itemContainerView == nil) {
        UIView *view = [UIView viewWithFrame:self.bounds backgroundColor:UIColorClear];
        view.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:view];
        self.itemContainerView = view;
    }
    if (self.buttonContainerView == nil) {
        UIView *view = [UIView viewWithFrame:self.bounds backgroundColor:UIColorClear];
        view.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:view];
        self.buttonContainerView = view;
    }
    if (self.overlayImageView == nil) {
        UIImageView *view = [UIImageView viewWithFrame:self.bounds backgroundColor:UIColorClear];
        view.contentMode = UIViewContentModeScaleToFill;
        view.image = self.overlayImage;
        view.userInteractionEnabled = NO;
        [self addSubview:view];
        self.overlayImageView = view;
    }
    [self addSubview:self.shadowImageView];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.indicatorContainerView];
    [self addSubview:self.itemContainerView];
    [self addSubview:self.buttonContainerView];
    [self addSubview:self.overlayImageView];
    
    self.clipsToBounds = NO;
}

-(void)layoutShadowView
{
    self.shadowImageView.hidden = (self.shadowImage == nil);
    UIImage *image = self.shadowImage;
    if (image != nil) {
        
        CGFloat height = image.size.height;
        self.shadowImageView.frame = CGRectMake(0.0f, -height, self.bounds.size.width, height);
        self.shadowImageView.image = image;
    }
}

-(void)layoutItems
{
    CGRect frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    NSArray *items = self.items;
    
    CGSize itemSize = self.itemSize;
    
    CGFloat itemSpacing = self.contentSpacing;
    
    UIView *itemContainerView = self.itemContainerView;
    UIView *buttonContainerView = self.buttonContainerView;
    
    NSArray *itemSubviews = itemContainerView.subviews;
    NSArray *buttonSubviews = buttonContainerView.subviews;
    
    NSInteger itemCount = items.count;
    NSInteger viewCount = itemSubviews.count;
    
    NSInteger maxCount = MAX(itemCount, viewCount);
    
    CGPoint offset = CGRectCenter(frame);
    offset.y = frame.origin.y;
    offset.x = offset.x - floor(((itemSize.width + itemSpacing) * (CGFloat)itemCount - itemSpacing)/2.0f);
    
    IDLTabBarItemView *itemView = nil;
    UIButton *button = nil;
    UITabBarItem *item = nil;
    
    UITabBarItem *selectedItem = self.selectedItem;
    
    IDLTabBarCustomizationBlock block = self.customizationBlock;
    
    BOOL hideSelectedIndicator = YES;
    
    for (NSInteger i = 0; i < maxCount; i++) {
        
        itemView = [itemSubviews objectAtIndexOrNil:i];
        item = [items objectAtIndexOrNil:i];
        button = [buttonSubviews objectAtIndexOrNil:i];
        
        if (i < itemCount) {
            frame = CGRectMake(offset.x + (itemSize.width + itemSpacing) * (CGFloat)i, offset.y, itemSize.width, itemSize.height);
            frame = CGRectRoundToInt(frame);
            if (itemView == nil) {
                itemView = [IDLTabBarItemView viewWithFrame:frame backgroundColor:UIColorClear];
                [itemContainerView addSubview:itemView];
            } else {
                itemView.frame = frame;
            }
            
            item.tag = i;
            
            BOOL selected = (item == selectedItem);
            
            itemView.tag = i;
            itemView.selected = selected;
            itemView.enabled = item.enabled;
            
            itemView.titleLabel.text = item.title;
            if (itemView.selected) {
                itemView.iconImageView.image = item.selectedImage;
            } else {
                itemView.iconImageView.image = item.image;
            }
            
            if (button == nil) {
                button = [UIButton viewWithFrame:frame backgroundColor:UIColorClear];
                [buttonContainerView addSubview:button];
            } else {
                button.frame = frame;
            }
            button.tag = i;
            button.enabled = item.enabled;
            button.selected = selected;
            [button removeAllTargets];
            [button addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIControlState controlState = UIControlStateNormal;
            
            if (selected) {
                [self setSelectedIndicatorFrame:frame];
                hideSelectedIndicator = NO;
                controlState = UIControlStateSelected;
            } else if (!item.enabled) {
                controlState = UIControlStateDisabled;
            }
            
            [itemView setTitleTextAttributes:[item titleTextAttributesForState:controlState]];
            
            if (block) {
                block(itemView, item);
            } else {
                [itemView setNeedsLayout];
            }
            
        } else {
            if (itemView != nil) [itemView removeFromSuperview];
            if (button != nil) {
                [button removeAllTargets];
                [button removeFromSuperview];
            }
        }
    }
    self.selectedIndicatorImageView.hidden = hideSelectedIndicator;
}

-(void)setSelectedIndicatorFrame:(CGRect)frame
{
    if (self.selectedIndicatorImageView == nil) {
        UIImageView *view = [UIImageView viewWithFrame:frame backgroundColor:UIColorClear];
        view.contentMode = UIViewContentModeCenter;
        view.image = self.selectionIndicatorImage;
        [self.indicatorContainerView addSubview:view];
        self.selectedIndicatorImageView = view;
    } else {
        self.selectedIndicatorImageView.frame = frame;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutContainerViews];
    [self layoutShadowView];
    [self layoutItems];
}

-(void)itemButtonAction:(id)sender
{
    UIButton *senderButton = CLASS_OR_NIL(sender, UIButton);
    
    if (senderButton.enabled) {
        [self setSelectedIndex:senderButton.tag notifyDelegate:YES];
    }
}

-(void)notifyTabBarDelegateDidSelectItem:(UITabBarItem *)item
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [self.delegate tabBar:self didSelectItem:item];
    }
}

-(CGSize)itemSize
{
    CGRect frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    CGSize size = frame.size;
    
    CGFloat itemCount = self.items.count;
    
    if (itemCount > 1.0f) {
        size.width = size.width - (self.contentSpacing * (itemCount - 1.0f));
        size.width = floor(size.width / itemCount);
    }
    
    CGFloat maxWidth = self.maximumItemWidth;
    
    if (maxWidth > 0.0f) {
        size.width = MIN(maxWidth, size.width);
    }
    
    return size;
}

-(void)setItems:(NSArray *)items
{
    _items = [items copy];
    
    self.selectedIndexHistory = nil;
    [self updateSelectedIndexHistory];
    
    [self setNeedsLayout];
}

-(void)setTabBarItemViewClass:(Class)tabBarItemViewClass
{
    if ([tabBarItemViewClass isSubclassOfClass:[IDLTabBarItemView class]]) {
        _tabBarItemViewClass = tabBarItemViewClass;
    } else {
        _tabBarItemViewClass = [IDLTabBarItemView class];
    }
}

-(void)setSelectionIndicatorImage:(UIImage *)selectionIndicatorImage
{
    _selectionIndicatorImage = selectionIndicatorImage;
    self.selectedIndicatorImageView.image = selectionIndicatorImage;
}

-(void)setSelectedItem:(UITabBarItem *)selectedItem notifyDelegate:(BOOL)notifyDelegate
{
    _selectedItem = selectedItem;
    [self updateSelectedIndexHistory];
    [self setNeedsLayout];
    
    if (notifyDelegate) {
        [self notifyTabBarDelegateDidSelectItem:selectedItem];
    }
}

-(void)setSelectedItem:(UITabBarItem *)selectedItem
{
    [self setSelectedItem:selectedItem notifyDelegate:NO];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex notifyDelegate:(BOOL)notifyDelegate
{
    UITabBarItem *item = [_items objectAtIndexOrNil:selectedIndex];
    [self setSelectedItem:item notifyDelegate:notifyDelegate];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex notifyDelegate:NO];
}

-(NSInteger)selectedIndex
{
    NSInteger index = [_items indexOfObject:self.selectedItem];
    if (index == NSNotFound) index = -1;
    return index;
}

-(NSInteger)lastSelectedIndex
{
    NSArray *history = self.selectedIndexHistory;
    if (history.count > 1) {
        return [[history objectAtIndex:(history.count-2)] integerValue];
    } else {
        return -1;
    }
}

-(void)updateSelectedIndexHistory
{
    NSInteger currentSelectedIndex = self.selectedIndex;
    NSArray *history = self.selectedIndexHistory;
    if (history == nil) {
        self.selectedIndexHistory = @[@(currentSelectedIndex)];
    } else {
        NSInteger lastSelectedIndex = [history.lastObject integerValue];
        if (lastSelectedIndex != currentSelectedIndex) {
            history = [history arrayByAddingObject:@(currentSelectedIndex)];
            self.selectedIndexHistory = history;
        }
    }
}

@end
