//
//  UIScrollView+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/08/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (IDLScrollIndicatorsVisible)

@property (nonatomic, assign) BOOL horizontalScrollIndicatorVisible;
@property (nonatomic, assign) BOOL verticalScrollIndicatorVisible;

@end

@interface UIScrollView  (IDLPlatform)

-(BOOL)platformReuseIdentifiableCellClassNib:(Class)reuseIdentifiableCellClass registeredFromBundle:(NSBundle *)bundle type:(NSString *)type;

@end
