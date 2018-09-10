//
//  IDLSkinDefinition.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLSkinDefinition.h"
#import "IDLCommonMacros.h"

@implementation IDLSkinDefinition

-(id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    IDLSkinDefinition *copy = [[[self class] alloc] init];
    
    [self copyProperties:copy];
    
    return copy;
}

- (void)copyProperties:(IDLSkinDefinition *)destination
{
    IDLSKIN_COPY_PROPERTY(destination, uid);
    IDLSKIN_COPY_PROPERTY(destination, name);
}

-(UIImage *)resizableImageWithImage:(UIImage *)image capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
{
    if (image == nil || UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero)) {
        return image;
    } else {
        return [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    }
}

-(void)configure
{
    // do nothing
}

@end
