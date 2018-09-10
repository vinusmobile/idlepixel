//
//  IDLActionSheet.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 6/05/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLObjectProtocols.h"

@interface IDLActionSheet : UIActionSheet <IDLConfigurable>

@property (nonatomic, strong, readonly) UITapGestureRecognizer *dismissTapOutRecognizer;

-(void)dismissWithTapOut:(UITapGestureRecognizer *)recognizer;

@end
