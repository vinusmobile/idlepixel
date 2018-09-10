//
//  IDLButton.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLButton.h"

@implementation IDLButton

-(id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
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

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self refreshSelectedHighlighted];
}

-(void)refreshSelectedHighlighted
{
    [self executeSelectedHighlightedBlock:self.selected highlighted:self.highlighted animated:self.animateSelectedHighlighted];
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

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected];
    [self executeSelectedHighlightedBlock:selected highlighted:self.highlighted animated:self.animateSelectedHighlighted];
}

@end
