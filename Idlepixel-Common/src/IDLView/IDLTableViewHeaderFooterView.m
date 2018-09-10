//
//  IDLTableViewHeaderFooterView.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLTableViewHeaderFooterView.h"
#import "UIView+NibProperties.h"
#import "NSObject+Idlepixel.h"

@implementation IDLTableViewHeaderFooterView

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

-(CGFloat)calculatedHeight
{
    return self.calculatedSize.height;
}

-(CGSize)calculatedSize
{
    return self.frame.size;
}

@end
