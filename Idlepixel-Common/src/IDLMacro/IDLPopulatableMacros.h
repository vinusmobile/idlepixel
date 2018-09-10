//
//  IDLPopulatableMacros.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 11/06/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#ifndef Idlepixel_Common_IDLPopulatableMacros_h
#define Idlepixel_Common_IDLPopulatableMacros_h

#pragma mark - IDLPopulatableViewController -

// -(IDLPopulatableViewAssistantManager *)populatableAssistantManager

#define IDL_POPULATABLE_populatableAssistantManager() \
-(IDLPopulatableViewAssistantManager *)populatableAssistantManager\
{\
    return [IDLPopulatableViewAssistantManager sharedManager];\
}

// +(void)registerPopulatableViewControllerAssistants:(IDLPopulatableViewAssistantManager *)manager

#define IDL_POPULATABLE_registerPopulatableViewControllerAssistants() \
+(void)registerPopulatableViewControllerAssistants:(IDLPopulatableViewAssistantManager *)manager\
{\
    /* do nothing, meant for override */ \
}

#pragma mark - Groupings -

// IDL_POPULATABLE_IDLPopulatableViewController()

#define IDL_POPULATABLE_IDLPopulatableViewController() \
\
IDL_POPULATABLE_populatableAssistantManager()\
\
IDL_POPULATABLE_registerPopulatableViewControllerAssistants()

#endif
