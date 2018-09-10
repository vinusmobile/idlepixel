//
//  UIView+NibProperties.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLNibProperties.h"

@interface UIView (NibProperties)

+(void)saveNibPropertiesForNibLoadedView:(UIView *)view;
-(void)saveNibProperties;

+(IDLNibProperties *)nibProperties;
-(IDLNibProperties *)nibProperties;

@end
