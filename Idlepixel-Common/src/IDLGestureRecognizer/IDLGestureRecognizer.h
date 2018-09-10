//
//  IDLGestureRecognizer.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 28/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@protocol IDLGestureRecognizer <NSObject>

@required
-(BOOL)preventsGestureRecognizers;
-(BOOL)canBePreventedByGestureRecognizers;

@end
