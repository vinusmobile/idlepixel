//
//  IDLPhoneManager.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 16/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractSharedSingleton.h"

@interface IDLPhoneManager : IDLAbstractSharedSingleton

+(instancetype)sharedManager;

-(void)callPhoneNumber:(NSString *)phoneNumber;
@property (readonly) BOOL supportsPhoneCalls;

+(BOOL)supportsPhoneCalls;

@end
