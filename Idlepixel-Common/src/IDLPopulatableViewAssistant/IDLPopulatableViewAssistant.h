//
//  IDLPopulatableViewAssistant.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceProtocols.h"

@interface IDLPopulatableViewAssistant : NSObject <IDLPopulatableTableViewAssistant, IDLPopulatableCollectionViewAssistant>

+(id)assistantForViewController:(UIViewController *)controller;

@property (nonatomic, weak) UIViewController *viewController;

@end
