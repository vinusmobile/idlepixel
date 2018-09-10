//
//  IDLTextField.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLInterfaceProtocols.h"

@interface IDLTextField : UITextField <IDLLayoutOnAwakeFromNib>

@property (nonatomic, assign) UIEdgeInsets insets;

-(CGRect)insetRectForBounds:(CGRect)bounds;

@end
