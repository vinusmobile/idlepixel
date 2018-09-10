//
//  IDLSwipeGestureRecognizer.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 28/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLSwipeGestureRecognizer.h"
#import "IDLLoggingMacros.h"

@implementation IDLSwipeGestureRecognizer

-(BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    //IDLLogObject(preventedGestureRecognizer);
    //IDLLogInteger([super canPreventGestureRecognizer:preventedGestureRecognizer]);
    return self.preventsGestureRecognizers;
}

-(BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    //IDLLogObject(preventingGestureRecognizer);
    //IDLLogInteger([super canBePreventedByGestureRecognizer:preventingGestureRecognizer]);
    return self.canBePreventedByGestureRecognizers;
}

@end
