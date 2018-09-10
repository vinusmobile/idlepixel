//
//  IDLCollectionReusableView.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLCollectionReusableView.h"
#import "UIView+NibProperties.h"
#import "NSObject+Idlepixel.h"

@implementation IDLCollectionReusableView

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
    [self customLayoutSubviews];
}

-(void)removeFromSuperview
{
    self.actionResponseDelegate = nil;
    [super removeFromSuperview];
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
