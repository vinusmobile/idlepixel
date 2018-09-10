//
//  UIPickerView+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/12/2013.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UIPickerView+Idlepixel.h"

@implementation UIPickerView (Idlepixel)

-(NSIndexPath *)selectedIndexPath
{
    NSIndexPath *indexPath = nil;
    NSUInteger count = self.numberOfComponents;
    NSInteger index = 0;
    for (NSUInteger i = 0; i < count; i++) {
        index = [self selectedRowInComponent:i];
        if (indexPath == nil) {
            indexPath = [NSIndexPath indexPathWithIndex:index];
        } else {
            indexPath = [indexPath indexPathByAddingIndex:index];
        }
    }
    return indexPath;
}

-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    if (selectedIndexPath) {
        NSUInteger count = selectedIndexPath.length;
        NSUInteger componentsCount = self.numberOfComponents;
        NSUInteger index = NSNotFound;
        for (NSInteger i = 0; i < MIN(count, componentsCount); i++) {
            index = [selectedIndexPath indexAtPosition:i];
            if (index != NSNotFound && [self numberOfRowsInComponent:i] > index) {
                [self selectRow:index inComponent:i animated:YES];
            }
        }
    }
}

@end
