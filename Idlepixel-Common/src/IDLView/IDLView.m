//
//  IDLView.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/06/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLView.h"
#import "UIView+NibProperties.h"
#import "NSObject+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"
#import "IDLTouchNotifyingViewMacros.h"

@implementation IDLView

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

@implementation IDLTouchNotifyingView

IDL_TOUCHNOTIFYING_UIView_ALL

@end


