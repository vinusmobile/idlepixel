//
//  IDLFontStore.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLAbstractStore.h"

@interface IDLFontStore : IDLAbstractStore

-(void)storeFont:(UIFont *)aFont withIdentifier:(NSString *)identifier;
-(void)storeFont:(UIFont *)aFont withIdentifier:(NSString *)identifier style:(NSString *)style;
-(void)storeFont:(UIFont *)aFont withIdentifier:(NSString *)identifier style:(NSString *)style viewClass:(Class)viewClass;

-(UIFont *)storedFontWithIdentifier:(NSString *)identifier;
-(UIFont *)storedFontWithIdentifier:(NSString *)identifier style:(NSString *)style;
-(UIFont *)storedFontWithIdentifier:(NSString *)identifier style:(NSString *)style viewClass:(Class)viewClass;

@end
