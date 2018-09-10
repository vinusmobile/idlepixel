//
//  IDLPanGestureRecognizer.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 28/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLGestureRecognizer.h"

@interface IDLPanGestureRecognizer : UIPanGestureRecognizer <IDLGestureRecognizer>

@property (nonatomic, assign) BOOL preventsGestureRecognizers;
@property (nonatomic, assign) BOOL canBePreventedByGestureRecognizers;

@end
