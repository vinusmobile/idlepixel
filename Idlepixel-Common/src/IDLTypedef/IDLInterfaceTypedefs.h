//
//  IDLInterfaceEnums.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 14/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, IDLTypedUserInterfaceIdiom)
{
    IDLTypedUserInterfaceIdiomPhone         = UIUserInterfaceIdiomPhone,
    IDLTypedUserInterfaceIdiomPad           = UIUserInterfaceIdiomPad,
    IDLTypedUserInterfaceIdiomUnspecified
};

typedef NS_ENUM (NSUInteger, IDLInterfaceLockState)
{
    IDLInterfaceLockStateUnlocked           = 0,
    IDLInterfaceLockStateFrozen,
    IDLInterfaceLockStateOverlay
};

typedef NS_ENUM (NSUInteger, IDLInterfaceAlternatingFlag)
{
    IDLInterfaceAlternatingFlagUnspecified  = 0,
    IDLInterfaceAlternatingFlagOdd = 1,
    IDLInterfaceAlternatingFlagEven = 2,
    IDLInterfaceAlternatingFlagInitial = IDLInterfaceAlternatingFlagEven,
};

typedef NS_OPTIONS (NSUInteger, IDLInterfaceSide)
{
    IDLInterfaceSideUnknown                 = 0,
    IDLInterfaceSideTop                     = 1 << 0,
    IDLInterfaceSideLeft                    = 1 << 1,
    IDLInterfaceSideBottom                  = 1 << 2,
    IDLInterfaceSideRight                   = 1 << 3
};

typedef NS_OPTIONS (NSUInteger, IDLInterfaceItemPosition)
{
    IDLInterfaceItemPositionMiddle          = 0,
    IDLInterfaceItemPositionFirst           = 1 << 0,
    IDLInterfaceItemPositionLast            = 1 << 1,
    IDLInterfaceItemPositionSingle          = (IDLInterfaceItemPositionLast | IDLInterfaceItemPositionFirst)
};

typedef void (^IDLSelectedHighlightedBlock)(UIView *view, BOOL selected, BOOL highlighted, BOOL animated);
