//
//  IDLSkinDefinition.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IDLSkinningMacros.h"
#import "IDLObjectProtocols.h"

@interface IDLSkinDefinition : NSObject <NSCopying, IDLConfigurable>

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;

-(void)copyProperties:(IDLSkinDefinition *)destination;

-(UIImage *)resizableImageWithImage:(UIImage *)image capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;

@end
