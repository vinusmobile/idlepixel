//
//  IDLCollectionViewCell.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLCollectionViewCell.h"
#import "UIView+NibProperties.h"
#import "NSObject+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"

@interface IDLCollectionViewCell ()

@property (nonatomic, strong) NSDictionary *labelColorDictionary;

@end

@implementation IDLCollectionViewCell

+(NSString *)reuseIdentifier
{
    return [self className];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self configure];
    }
    return self;
}

-(void)handleAction:(SEL)actionSelector withSender:(id)sender
{
    if ([self.actionResponseDelegate respondsToSelector:@selector(actionEncountered:withSender:fromSource:)]) {
        [self.actionResponseDelegate actionEncountered:actionSelector withSender:sender fromSource:self];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self saveNibProperties];
    if (self.shouldLayoutOnAwakeFromNib) {
        [self layoutSubviews];
    }
}

-(BOOL)shouldLayoutOnAwakeFromNib
{
    return NO;
}

-(void)configure
{
    // do nothing
}

-(void)customLayoutSubviews
{
    // do nothing
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.flairBackgroundView != nil) {
        self.flairBackgroundView.frame = self.bounds;
    }
    
    [self customLayoutSubviews];
}

-(void)removeFromSuperview
{
    self.actionResponseDelegate = nil;
    [super removeFromSuperview];
}

-(void)setFlairBackgroundView:(UIView *)flairBackgroundView
{
    if (flairBackgroundView != _flairBackgroundView) {
        if (self.flairBackgroundView != nil) {
            [_flairBackgroundView removeFromSuperview];
        }
        _flairBackgroundView = flairBackgroundView;
        if (flairBackgroundView != nil) {
            flairBackgroundView.frame = self.bounds;
            [self.contentView insertSubview:flairBackgroundView atIndex:0];
        }
    }
}

-(void)saveTextLabelColor:(UILabel *)aLabel
{
    if (aLabel != nil) {
        if (self.labelColorDictionary == nil) {
            self.labelColorDictionary = [NSDictionary dictionaryWithObject:aLabel.textColor forKey:aLabel.pointerKey];
        } else {
            self.labelColorDictionary = [self.labelColorDictionary dictionaryByAddingObject:aLabel.textColor forKey:aLabel.pointerKey];
        }
    }
}

-(UIColor *)textLabelColor:(UILabel *)aLabel
{
    if (aLabel != nil) {
        return [self.labelColorDictionary objectForKey:aLabel.pointerKey];
    } else {
        return nil;
    }
}

-(void)restoreTextLabelColor:(UILabel *)aLabel
{
    aLabel.textColor = [self textLabelColor:aLabel];
}

-(void)executeSelectedHighlightedBlock:(BOOL)selected highlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.selectedHighlightedBlock != NULL) {
        self.selectedHighlightedBlock(self, selected, highlighted, animated);
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self executeSelectedHighlightedBlock:self.selected highlighted:highlighted animated:self.animateSelectedHighlighted];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self executeSelectedHighlightedBlock:selected highlighted:self.highlighted animated:self.animateSelectedHighlighted];
}

-(CGFloat)calculatedHeight
{
    return self.calculatedSize.height;
}

-(CGSize)calculatedSize
{
    return self.frame.size;
}

@end
