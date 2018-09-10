//
//  UIImageView+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 14/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImageView (IDLCrossfade)

- (void)crossfadeToImage:(UIImage *)image withDuration:(NSTimeInterval)interval;

@end

@interface UIImageView (IDLScrollIndicatorsVisible)

@end
