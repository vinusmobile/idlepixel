//
//  IDLImageView.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 26/02/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLObjectProtocols.h"
#import "IDLInterfaceProtocols.h"

@interface IDLImageView : UIImageView <IDLConfigurable, IDLLayoutOnAwakeFromNib>

@end
