//
//  IDLImageView.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 26/02/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLImageView.h"

@implementation IDLImageView

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

@end
