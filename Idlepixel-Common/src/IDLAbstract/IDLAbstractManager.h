//
//  IDLAbstractManager.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/11/2013.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLNotificationObserverProtocol.h"
#import "IDLObjectProtocols.h"

@interface IDLAbstractManager : NSObject <IDLNotificationObservant, IDLConfigurable>

@end
