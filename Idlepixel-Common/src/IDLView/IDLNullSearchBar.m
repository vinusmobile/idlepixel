//
//  IDLNullSearchBar.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLNullSearchBar.h"

@interface IDLNullSearchBar ()

-(void)configureView;

@end

@implementation IDLNullSearchBar

-(id)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

-(void)configureView
{
    self.alpha = 0.0f;
    self.userInteractionEnabled = NO;
    self.hidden = YES;
}

-(void)setAlpha:(CGFloat)alpha
{
    super.alpha = 0.0f;
}

-(void)setHidden:(BOOL)hidden
{
    super.hidden = YES;
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    super.userInteractionEnabled = NO;
}

-(CGRect)frame
{
    return CGRectZero;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeZero;
}

-(void)setText:(NSString *)text
{
    super.text = text;
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        IDLLogObject(text);
        [self.delegate searchBar:self textDidChange:text];
    }
}

-(void)drawRect:(CGRect)rect
{
    // do literally nothing
}

@end
