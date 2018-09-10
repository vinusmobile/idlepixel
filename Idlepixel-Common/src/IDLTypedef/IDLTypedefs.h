//
//  IDLEnums.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

typedef NS_ENUM (NSInteger, IDLAlertLevel)
{
    IDLAlertLevelUndefined     = 0,
    IDLAlertLevelInformation,
    IDLAlertLevelWarning,
    IDLAlertLevelError,
    IDLAlertLevelCritical,
};

// used in IDLLabel

typedef NS_ENUM (NSUInteger, IDLVerticalAlignment)
{
    IDLVerticalAlignmentStandard = 0,
    IDLVerticalAlignmentTop,
    IDLVerticalAlignmentMiddle,
    IDLVerticalAlignmentBottom
};

// used in IDLProgressView

typedef NS_ENUM (NSUInteger, IDLProgressViewAnimation)
{
    IDLProgressViewAnimationNone = 0,
    IDLProgressViewAnimationNormal,
    IDLProgressViewAnimationLimit
};

typedef NS_ENUM (NSUInteger, IDLProgressViewLeadingEdge)
{
    IDLProgressViewLeadingEdgeStandard = 0,
    IDLProgressViewLeadingEdgeLeft = IDLProgressViewLeadingEdgeStandard,
    IDLProgressViewLeadingEdgeRight,
    IDLProgressViewLeadingEdgeTop,
    IDLProgressViewLeadingEdgeBottom
};


typedef NS_ENUM (NSInteger, IDLComparisonResult)
{
    IDLComparisonResultInconclusive = -1,
    IDLComparisonResultNotEqual     = 0,
    IDLComparisonResultEqual        = 1
};

// used in NSBundle+Idlepixel

typedef NS_OPTIONS (NSInteger, IDLIdentifierPrecision)
{
    IDLIdentifierPrecisionNone          = 0,
    IDLIdentifierPrecisionBundle        = 1 << 0,
    IDLIdentifierPrecisionDevice        = 1 << 1,
    IDLIdentifierPrecisionVersion       = 1 << 2,
    IDLIdentifierPrecisionLaunch        = 1 << 3,
};

// used in UIDevice+Idlepixel

typedef struct
{
	NSInteger major;
	NSInteger minor;
	NSInteger point;
	NSInteger build;
} IDLVersion;

typedef IDLVersion IDLSystemVersion;

#define IDLVersionZero  (IDLVersion){ 0, 0, 0, 0 }
#define IDLVersionMax   (IDLVersion){ NSIntegerMax, NSIntegerMax, NSIntegerMax, NSIntegerMax }
#define IDLVersionMin   (IDLVersion){ NSIntegerMin, NSIntegerMin, NSIntegerMin, NSIntegerMin }

typedef void (^VoidBlock)(void);

typedef struct
{
	NSInteger hours;
	NSInteger minutes;
	NSInteger seconds;
} IDLTime;

#define IDLTimeMidnight (IDLTime){ 0, 0, 0 }

typedef struct
{
	NSTimeInterval start;
	NSTimeInterval duration;
} IDLTimeIntervalRange;

typedef struct
{
	CGFloat location;
	CGFloat length;
} IDLFloatRange;

