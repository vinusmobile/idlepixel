//
//  IDLViewStore.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLProtocolHeaders.h"
#import "IDLAbstractStore.h"

@interface IDLViewStore : IDLAbstractStore

-(void)storeView:(UIView *)aView withReuseIdentifier:(NSString *)reuseIdentifier;
-(void)storeView:(UIView *)aView withReuseIdentifier:(NSString *)reuseIdentifier caller:(NSString *)caller;

-(id)storedViewWithReuseIdentifier:(NSString *)reuseIdentifier;
-(id)storedViewWithReuseIdentifier:(NSString *)reuseIdentifier caller:(NSString *)caller;

-(id)platformSubclassInstanceWithReuseIdentifier:(NSString *)reuseIdentifier;
-(id)platformSubclassInstanceWithReuseIdentifier:(NSString *)reuseIdentifier caller:(NSString *)caller;

@end
