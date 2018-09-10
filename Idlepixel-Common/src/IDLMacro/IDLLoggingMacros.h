//
//  LoggingMacros.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 15/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <objc/runtime.h>
#import "IDLCommonMacros.h"
#import "NSObject+Idlepixel.h"

#ifndef Idlepixel_Common_IDLLoggingMacros_h
#define Idlepixel_Common_IDLLoggingMacros_h


#ifdef DEBUG
#define IDLLog(_fmt_, ...) NSLog((@"%@ [%i]: " _fmt_), self.pointerKey, __LINE__, ##__VA_ARGS__)
#define IDLLogBool(__obj__) IDLLog(@"%s = %@",ObjectToChars(__obj__), (__obj__ ? @"YES" : @"NO"))
#define IDLLogContext(_fmt_, ...) NSLog((@"%s [%i]: " _fmt_), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define IDLLogObject(__obj__) IDLLog(@"%s = '%@'",ObjectToChars(__obj__), __obj__)
#define IDLLogClass(__obj__) IDLLog(@"%s = %@",ObjectToChars(__obj__), NSStringFromClass(__obj__))
#define IDLLogFloat(__obj__) IDLLog(@"%s = '%f'",ObjectToChars(__obj__), __obj__)
#define IDLLogInteger(__obj__) IDLLog(@"%s = '%i'",ObjectToChars(__obj__), __obj__)
#define IDLLogRange(__obj__) IDLLog(@"%s = %@",ObjectToChars(__obj__), NSStringFromRange(__obj__))
#define IDLLogRect(__obj__) IDLLog(@"%s = %@",ObjectToChars(__obj__), NSStringFromCGRect(__obj__))
#define IDLLogSize(__obj__) IDLLog(@"%s = %@",ObjectToChars(__obj__), NSStringFromCGSize(__obj__))
#define IDLLogPoint(__obj__) IDLLog(@"%s = %@",ObjectToChars(__obj__), NSStringFromCGPoint(__obj__))
#define IDLLogEdgeInsets(__obj__) IDLLog(@"%s = %@",ObjectToChars(__obj__), NSStringFromUIEdgeInsets(__obj__))
#define IDLLogSelector(__obj__) IDLLog(@"%s = %@",ObjectToChars(__obj__), NSStringFromSelector(__obj__))

#define IDLLogLine() IDLLogContext(@"%s<%p>",class_getName(self.class),self)

#else
#define IDLLog(...)
#define IDLLogBool(...)
#define IDLLogContext(...)
#define IDLLogObject(...)
#define IDLLogClass(...)
#define IDLLogFloat(...)
#define IDLLogInteger(...)
#define IDLLogRange(...)
#define IDLLogRect(...)
#define IDLLogSize(...)
#define IDLLogPoint(...)
#define IDLLogEdgeInsets(...)
#define IDLLogSelector(...)

#define IDLLogLine(...)

#endif


#ifdef IDLEPIXEL_DLOG
#ifndef DLog
#define DLog IDLLog
#endif
#endif

#endif
