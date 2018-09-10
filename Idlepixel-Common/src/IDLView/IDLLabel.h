//
//  IDLLabel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLTypedefs.h"
#import "IDLObjectProtocols.h"
#import "IDLInterfaceProtocols.h"


@interface IDLLabel : UILabel <IDLConfigurable, IDLLayoutOnAwakeFromNib>

@property (nonatomic, readwrite, assign) IDLVerticalAlignment verticalAlignment;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat kerning;

// glow
@property (nonatomic, assign) CGSize glowOffset;
@property (nonatomic, assign) CGFloat glowAmount;
@property (nonatomic, strong) UIColor *glowColor;

// stroke
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;

@end
