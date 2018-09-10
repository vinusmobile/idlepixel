//
//  IDLCommonMacros.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#ifndef Idlepixel_IDLCommonMacros
#define Idlepixel_IDLCommonMacros

#define NSTimeIntervalDistantFuture     FLT_MAX
#define NSTimeIntervalQuarterSecond     0.25f
#define NSTimeIntervalHalfSecond        0.5f
#define NSTimeIntervalSecond            1.0f
#define NSTimeIntervalMinute            60.0f
#define NSTimeIntervalMinutesFive       300.0f
#define NSTimeIntervalMinutesTen        600.0f
#define NSTimeIntervalHour              3600.0f
#define NSTimeIntervalDay               86400.0f

#ifndef RETURN_IF_CLASS
#define RETURN_IF_CLASS(object, requiredClass) (\
{\
if ([object isKindOfClass:[requiredClass class]]) {\
return (requiredClass *)object;\
} else {\
return nil;\
}\
})
#endif

#ifndef CLASS_OR_NIL
#define CLASS_OR_NIL(object, requiredClass) (([object isKindOfClass:[requiredClass class]]) ? (requiredClass *)object : nil)
#endif

#ifndef CLASS_OR_DEFAULT
#define CLASS_OR_DEFAULT(object, defaultObject, requiredClass) (([object isKindOfClass:[requiredClass class]]) ? (requiredClass *)object : defaultObject)
#endif

#ifndef VALUE_OR_DEFAULT
#define VALUE_OR_DEFAULT(object, defaultObject) ((object != nil) ? object : defaultObject)
#endif

#define ASSIGN_NOT_EQUAL_NOT_NIL(property, val) ({\
id __val = (val);\
id __existing = property;\
if (__val != __existing && (__val != [NSNull null] && __val != nil) && (__val == nil || __existing == nil || ![__val isEqual:__existing]))\
{\
property = val;\
} else {\
}\
})

#define ASSIGN_NOT_NIL(property, val) ({ id __val = (val); if (__val != [NSNull null] && __val != nil) { property = val; }})

#define ASSIGN_ANY_VAL(property, val) ({ property = val; })

#define ASSIGN_NOT_EQUAL(property, val) ({\
id __val = (val);\
id __existing = property;\
if (__val != __existing && (__val == nil || __existing == nil || ![__val isEqual:__existing]))\
{\
property = val;\
} else {\
}\
})

#define IDL_GETTER_AUTOCREATE(__property__, __property_class__) \
-(__property_class__ *)__property__ \
{\
if (![_##__property__ isKindOfClass:[__property_class__ class]]) {\
_##__property__ = [__property_class__ new];\
}\
return _##__property__;\
}

#define IDL_GETTER_AUTOCREATE_SUPER(__property__, __property_class__) \
-(__property_class__ *)__property__ \
{\
if (![super.__property__ isKindOfClass:[__property_class__ class]]) {\
super.__property__ = [__property_class__ new];\
}\
return super.__property__;\
}

#define IDL_RETURN_SINGLETON(__class__) \
__strong static __class__ *shared = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
shared = [__class__ new];\
});\
return shared;


#define IDL_COPY_PROPERTY(__copy__, __property__) __copy__.__property__ = _##__property__


#if !defined(NSNULL)
#define NSNULL [NSNull null]
#endif

#if !defined(RANGE)
#define RANGE(MIN, value, MAX)	({ __typeof__(MIN) __min = (MIN); __typeof__(value) __value = (value); __typeof__(MAX) __max = (MAX); __value < __min ? __min : (__value > __max ? __max : __value); })
#endif

#if !defined(RANGE_NORMAL)
#define RANGE_NORMAL(min, value, max)	((double)(RANGE((double)(min), (double)(value), (double)(max)) - (double)(min))/((double)(max) - (double)(min)))
#endif

#if !defined(POSITION)
#define POSITION(value1, value2, position)	((value1 + (value2 - value1) * position))
#endif

#if !defined(randb)
#define randb()	((rand() % 2) == 0)
#endif

#if !defined(randf)
#define randf()	(rand()/(float)RAND_MAX)
#endif

#if !defined(randsign)
#define randsign()	(((int)(rand() % 2) * 2) - 1)
#endif

#if !defined(randsignf)
#define randsignf()	((float)randsign())
#endif

#if !defined(randrange)
#define randrange(min, max)	((rand() % ((int)max - (int)min)) + (int)min)
#endif

#if !defined(randrangef)
#define randrangef(min, max)	((randf() * ((float)max - (float)min)) + (float)min)
#endif

#if !defined(randd)
#define randd()	(rand()/(double)RAND_MAX)
#endif

#if !defined(floor_even)
#define floor_even(value) (floor((double)value / 2.0f) * 2.0f)
#endif

#if !defined(ceil_even)
#define ceil_even(value) (ceil((double)value / 2.0f) * 2.0f)
#endif


#define ObjectToChars(__x__) ObjectToChars_Private(__x__)
#define ObjectToChars_Private(__x__) #__x__

#define ObjectToNSString(__obj__) [NSString stringWithFormat:@"%s",ObjectToChars(__obj__)]

#define ObjectWithOwnerToNSString(__obj__, __owner__) [NSString stringWithFormat:@"%@:%s",NSStringFromClass([__owner__ class]),ObjectToChars(__obj__)]

#define ObjectToNSStringWithClass(__obj__) ObjectWithOwnerToNSString(__obj__, __obj__)

#endif
