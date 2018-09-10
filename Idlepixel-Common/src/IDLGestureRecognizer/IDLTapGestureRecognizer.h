//
//  IDLTapGestureRecognizer.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/09/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLGestureRecognizer.h"

@interface IDLTapGestureRecognizer : UITapGestureRecognizer <IDLGestureRecognizer>

@property (nonatomic, assign) BOOL preventsGestureRecognizers;
@property (nonatomic, assign) BOOL canBePreventedByGestureRecognizers;

@end
