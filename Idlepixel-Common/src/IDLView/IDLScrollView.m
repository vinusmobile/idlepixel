//
//  IDLScrollView.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/08/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLScrollView.h"
#import "IDLTouchNotifyingViewMacros.h"

@implementation IDLScrollView

IDL_TOUCHNOTIFYING_UIView_ALL

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self adjustContentSize];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustContentSize];
}

-(void)adjustContentSize
{
    if (self.contentSizeView != nil) {
        self.contentSize = self.contentSizeView.frame.size;
    }
}

@end
