//
//  IDLPersistentMacros.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 25/06/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#ifndef Idlepixel_Common_IDLPersistentMacros_h
#define Idlepixel_Common_IDLPersistentMacros_h

#import "NSMutableDictionary+Idlepixel.h"

#define IDLPersistentKey(property, owner)   (ObjectWithOwnerToNSString(property, owner))
#define IDLPersistentKeySelf(property)      (ObjectWithOwnerToNSString(property, self))

// setters

#define IDLDictionarySetBoolFromProperty(dictionary, property) ([dictionary setBool:property forKey:IDLPersistentKeySelf(property)])
#define IDLDictionarySetFloatFromProperty(dictionary, property) ([dictionary setFloat:property forKey:IDLPersistentKeySelf(property)])
#define IDLDictionarySetIntegerFromProperty(dictionary, property) ([dictionary setInteger:property forKey:IDLPersistentKeySelf(property)])
#define IDLDictionarySetUnsignedIntegerFromProperty(dictionary, property) ([dictionary setUnsignedInteger:property forKey:IDLPersistentKeySelf(property)])

#define IDLDictionarySetPointFromProperty(dictionary, property) ([dictionary setPoint:property forKey:IDLPersistentKeySelf(property)])
#define IDLDictionarySetRectFromProperty(dictionary, property) ([dictionary setRect:property forKey:IDLPersistentKeySelf(property)])
#define IDLDictionarySetSizeFromProperty(dictionary, property) ([dictionary setSize:property forKey:IDLPersistentKeySelf(property)])

#define IDLDictionarySetObjectFromProperty(dictionary, property) ([dictionary setObjectIfNotNil:property forKey:IDLPersistentKeySelf(property)])

// getters

#define IDLDictionaryGetBoolForProperty(dictionary, property) ([dictionary boolForKey:IDLPersistentKeySelf(property)])
#define IDLDictionaryGetFloatForProperty(dictionary, property) ([dictionary floatForKey:IDLPersistentKeySelf(property)])
#define IDLDictionaryGetIntegerForProperty(dictionary, property) ([dictionary integerForKey:IDLPersistentKeySelf(property)])
#define IDLDictionaryGetUnsignedIntegerForProperty(dictionary, property) ([dictionary unsignedIntegerForKey:IDLPersistentKeySelf(property)])

#define IDLDictionaryGetPointForProperty(dictionary, property) ([dictionary pointForKey:IDLPersistentKeySelf(property)])
#define IDLDictionaryGetRectForProperty(dictionary, property) ([dictionary rectForKey:IDLPersistentKeySelf(property)])
#define IDLDictionaryGetSizeForProperty(dictionary, property) ([dictionary sizeForKey:IDLPersistentKeySelf(property)])

#define IDLDictionaryGetObjectForProperty(dictionary, property) ([dictionary objectForKey:IDLPersistentKeySelf(property)])


#endif
