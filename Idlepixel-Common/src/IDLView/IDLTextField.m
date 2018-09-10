//
//  IDLTextField.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLTextField.h"
#import "IDLLoggingMacros.h"

@interface IDLTextField ()



@end

@implementation IDLTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(CGRect)insetRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.insets);
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self insetRectForBounds:bounds];
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self insetRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self insetRectForBounds:bounds];
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    bounds = [self insetRectForBounds:bounds];
    return [super clearButtonRectForBounds:bounds];
}

@end
