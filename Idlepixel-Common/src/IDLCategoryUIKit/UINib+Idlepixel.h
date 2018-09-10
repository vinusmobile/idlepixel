//
//  UINib+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINib (IDLPlatform)

+ (UINib *)platformNibWithNibName:(NSString *)name;
+ (UINib *)platformNibWithNibName:(NSString *)name bundle:(NSBundle *)bundleOrNil;
+ (UINib *)platformNibForClass:(Class)nibClass;
+ (UINib *)platformNibForClass:(Class)nibClass bundle:(NSBundle *)bundleOrNil;

@end
