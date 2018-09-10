//
//  IDLButton.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLInterfaceProtocols.h"
#import "IDLInterfaceTypedefs.h"
#import "IDLObjectProtocols.h"

@interface IDLButton : UIButton <IDLConfigurable, IDLLayoutOnAwakeFromNib>

@property (nonatomic, assign) BOOL animateSelectedHighlighted;
@property (nonatomic, copy) IDLSelectedHighlightedBlock selectedHighlightedBlock;

-(void)refreshSelectedHighlighted;

@end
