//
//  IDLCGInlineExtensions.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 15/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#import "IDLTypedefs.h"
#import "IDLCommonMacros.h"

#ifndef Idlepixel_Common_IDLCGInlineExtensions_h
#define Idlepixel_Common_IDLCGInlineExtensions_h

#pragma mark - Degrees <-> Radians

CG_INLINE CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180.0f;
}

CG_INLINE CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180.0f / M_PI;
}

#pragma mark - CG Helpers

CG_INLINE CGRect CGRectSetMinX(CGRect rect, CGFloat minX)
{
    CGRect r = rect;
    r.origin.x = minX;
    r.size.width = rect.size.width + (r.origin.x - minX);
    return r;
}

CG_INLINE CGRect CGRectSetMinY(CGRect rect, CGFloat minY)
{
    CGRect r = rect;
    r.origin.y = minY;
    r.size.height = rect.size.height + (r.origin.y - minY);
    return r;
}

CG_INLINE CGRect CGRectSetX(CGRect rect, CGFloat x)
{
	CGRect r = rect;
	r.origin.x = x;
	return r;
}

CG_INLINE CGPoint CGPointDelta(CGPoint source, CGPoint destination)
{
    return CGPointMake(destination.x - source.x, destination.y - source.y);
}

CG_INLINE CGFloat CGPointLengthSquared(CGPoint point)
{
    return pow(point.x, 2.0f) + pow(point.y, 2.0f);
}

CG_INLINE CGFloat CGPointLength(CGPoint point)
{
    CGFloat lengthSquared = CGPointLengthSquared(point);
    if (lengthSquared > 0.0f) {
        return sqrt(lengthSquared);
    } else {
        return 0.0f;
    }
}

CG_INLINE CGPoint CGRectCenter(CGRect rect)
{
	return CGPointMake(rect.origin.x + (rect.size.width / 2), rect.origin.y + (rect.size.height / 2));
}

CG_INLINE CGRect CGRectExpand(CGRect rect, CGFloat width, CGFloat height)
{
    return CGRectMake(rect.origin.x - width/2.0f, rect.origin.y - height/2.0f, rect.size.width + width, rect.size.height + height);
}

CG_INLINE CGRect CGRectExpandBySize(CGRect rect, CGSize size)
{
    return CGRectExpand(rect, size.width, size.height);
}

CG_INLINE CGFloat CGRectGetRadius(CGRect rect)
{
    CGFloat radius = pow(CGRectGetWidth(rect), 2.0f) + pow(CGRectGetHeight(rect), 2.0f);
    if (radius > 0.0f) radius = sqrt(radius)/2.0f;
    return radius;
}

CG_INLINE CGRect CGRectSetY(CGRect rect, CGFloat y)
{
	CGRect r = rect;
	r.origin.y = y;
	return r;
}

CG_INLINE CGRect CGRectSetOrigin(CGRect rect, CGPoint origin)
{
	CGRect r = rect;
	r.origin = origin;
	return r;
}

CG_INLINE CGRect CGRectSetCenter(CGRect rect, CGPoint center)
{
    center.x = center.x - rect.size.width/2.0f;
    center.y = center.y - rect.size.height/2.0f;
    return CGRectSetOrigin(rect, center);
}

CG_INLINE CGRect CGRectSetSize(CGRect rect, CGSize size)
{
	CGRect r = rect;
	r.size = size;
	return r;
}

CG_INLINE CGRect CGRectSetWidth(CGRect rect, CGFloat width)
{
	CGRect r = rect;
	r.size.width = width;
	return r;
}

CG_INLINE CGRect CGRectSetHeight(CGRect rect, CGFloat height)
{
	CGRect r = rect;
	r.size.height = height;
	return r;
}

CG_INLINE CGRect CGRectSetRelativeWidth(CGRect rect, CGFloat relativeWidth)
{
	CGRect r = rect;
	r.size.width = r.size.width + relativeWidth;
	return r;
}

CG_INLINE CGRect CGRectSetRelativeHeight(CGRect rect, CGFloat relativeHeight)
{
	CGRect r = rect;
	r.size.height = r.size.height + relativeHeight;
	return r;
}

CG_INLINE CGRect CGRectMakeWithPointAndSize(CGPoint origin, CGSize size)
{
	CGRect r;
	r.origin = origin;
	r.size = size;
	return r;
}

CG_INLINE CGRect CGRectCenteredInnerRect(CGPoint centrePoint, CGSize size)
{
	CGRect r;
	r.origin = CGPointMake(centrePoint.x - (size.width / 2), centrePoint.y - (size.height / 2));
	r.size = size;
	return r;
}

CG_INLINE CGRect CGRectCenteredInsideRect(CGRect outerRect, CGRect innerRect)
{
	//CGPoint center =
	return CGRectCenteredInnerRect(CGRectCenter(outerRect), innerRect.size);
}

CG_INLINE CGRect CGRectSwapXY(CGRect rect)
{
	return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
}

CG_INLINE CGRect CGRectSwapOrigin(CGRect rect)
{
	return CGRectMake(rect.origin.y, rect.origin.x, rect.size.width, rect.size.height);
}

CG_INLINE CGRect CGRectSubtract(CGRect rect1, CGRect rect2)
{
	CGRect r = rect1;
	if (CGRectGetWidth(rect1) == CGRectGetWidth(rect2)) {
		if (CGRectGetMinY(rect1) == CGRectGetMinY(rect2)) {
			r.origin.y += CGRectGetHeight(rect2);
			r.size.height -= CGRectGetHeight(rect2);
		} else if (CGRectGetMaxY(rect1) == CGRectGetMaxY(rect2)) {
			r.size.height -= CGRectGetHeight(rect2);
		}
	} else if (CGRectGetHeight(rect1) == CGRectGetHeight(rect2)) {
		if (CGRectGetMinX(rect1) == CGRectGetMinX(rect2)) {
			r.origin.x += CGRectGetWidth(rect2);
			r.size.width -= CGRectGetWidth(rect2);
		} else if (CGRectGetMaxX(rect1) == CGRectGetMaxX(rect2)) {
			r.size.width -= CGRectGetWidth(rect2);
		}
	}
	
	return r;
}

// Creates the smallest possible rect that contains both p1 and p2
CG_INLINE CGRect CGRectMakeContainingPoints(CGPoint p1, CGPoint p2)
{
    CGFloat minX = MIN(p1.x, p2.x);
    CGFloat maxX = MAX(p1.x, p2.x);
    CGFloat minY = MIN(p1.y, p2.y);
    CGFloat maxY = MAX(p1.y, p2.y);
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

// Creates the smallest possible rect that contains both r and p
CG_INLINE CGRect CGRectUnionPoint(CGRect r, CGPoint p)
{
    CGFloat minX = MIN(r.origin.x, p.x);
    CGFloat maxX = MAX(r.origin.x + r.size.width, p.x);
    CGFloat minY = MIN(r.origin.y, p.y);
    CGFloat maxY = MAX(r.origin.y + r.size.height, p.y);
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

CG_INLINE CGPoint CGPointMakeWithOffsetAngleAndLength(CGPoint offset, CGFloat angle, CGFloat length)
{
    return CGPointMake(offset.x + length * cos(angle), offset.y + length * sin(angle));
}

CG_INLINE CGPoint CGPointMakeWithAngleAndLength(CGFloat angle, CGFloat length)
{
    return CGPointMakeWithOffsetAngleAndLength(CGPointZero, angle, length);
}

CG_INLINE CGPoint CGPointRoundToInt(CGPoint point)
{
	return CGPointMake(round(point.x), round(point.y));
}

CG_INLINE CGSize CGSizeRoundToInt(CGSize size)
{
	return CGSizeMake(round(size.width), round(size.height));
}

CG_INLINE CGSize CGSizeRoundUpToInt(CGSize size)
{
	return CGSizeMake(ceil(size.width), ceil(size.height));
}

CG_INLINE CGRect CGRectRoundToInt(CGRect rect)
{
    return CGRectMake(round(rect.origin.x), round(rect.origin.y), round(rect.size.width), round(rect.size.height));
}

CG_INLINE CGRect CGRectMakeAroundCenterPoint(CGPoint center, CGSize size)
{
	return CGRectMake(center.x - (size.width/2), center.y - (size.height/2), size.width, size.height);
}

CG_INLINE CGSize CGSizeSwap(CGSize size)
{
	return CGSizeMake(size.height, size.width);
}

CG_INLINE CGSize CGSizeScale(CGSize size, CGFloat scale)
{
	return CGSizeMake(size.width * scale, size.height * scale);
}

#pragma mark - range

CG_INLINE CGFloat CGFloatRange(CGFloat minimum, CGFloat value, CGFloat maximum)
{
    return RANGE(minimum, value, maximum);
}

CG_INLINE CGFloat CGFloatRangeLoop(CGFloat minimum, CGFloat value, CGFloat maximum)
{
    CGFloat denominator = maximum - minimum;
    if (denominator > 0.0f && (value > maximum || value < minimum)) {
        value = remainder(value - minimum, denominator);
        if (value < 0.0f) {
            value += maximum;
        } else {
            value += minimum;
        }
    }
    return value;
}

#pragma mark - interpolate

CG_INLINE CGPoint CGPointInterpolatePoints(CGPoint p1, CGPoint p2, CGFloat position)
{
    return CGPointMake((p2.x - p1.x) * position + p1.x, (p2.y - p1.y) * position + p1.y);
}

CG_INLINE CGSize CGSizeInterpolateSizes(CGSize s1, CGSize s2, CGFloat position)
{
    return CGSizeMake((s2.width - s1.width) * position + s1.width, (s2.height - s1.height) * position + s1.height);
}

CG_INLINE CGRect CGRectInterpolateRects(CGRect r1, CGRect r2, CGFloat position)
{
    return CGRectMakeWithPointAndSize(CGPointInterpolatePoints(r1.origin, r2.origin, position),
                                      CGSizeInterpolateSizes(r1.size, r2.size, position));
}

#pragma mark - NaN

CG_INLINE BOOL CGPointContainsNaN(CGPoint point)
{
    return (isnan(point.x) || isnan(point.y));
}

CG_INLINE BOOL CGSizeContainsNaN(CGSize size)
{
    return (isnan(size.width) || isnan(size.height));
}

CG_INLINE BOOL CGRectContainsNaN(CGRect rect)
{
    return (CGPointContainsNaN(rect.origin) || CGSizeContainsNaN(rect.size));
}

#pragma mark - IDLTime

CG_INLINE NSInteger IDLTimeMinutesIn24Hours()
{
    return 1440;
}

CG_INLINE NSInteger IDLTimeMinutesAfterMidnight(IDLTime time)
{
    return (time.hours * 60 + time.minutes);
}

CG_INLINE NSInteger IDLTimeSecondsAfterMidnight(IDLTime time)
{
    return (IDLTimeMinutesAfterMidnight(time) * 60 + time.seconds);
}

CG_INLINE NSInteger IDLTimeMinutesBeforeMidnight(IDLTime time)
{
    return (IDLTimeMinutesIn24Hours() - IDLTimeMinutesAfterMidnight(time));
}

CG_INLINE BOOL IDLTimeIsPM(IDLTime time)
{
    return (time.hours >= 12);
}

CG_INLINE BOOL IDLTimeIsAM(IDLTime time)
{
    return !IDLTimeIsPM(time);
}

CG_INLINE IDLTime IDLTime12HourFormat(IDLTime time)
{
    if (time.hours > 12) {
        time.hours = time.hours - 12;
    } else if (time.hours == 0) {
        time.hours = 12;
    }
    return time;
}

CG_INLINE IDLTime IDLTimeAddMinutes(IDLTime time, NSInteger minutes)
{
    while (minutes < 0) {
        minutes += IDLTimeMinutesIn24Hours();
    }
    minutes = minutes % IDLTimeMinutesIn24Hours();
    while (minutes >= 60) {
        time.hours = time.hours + 1;
        minutes -= 60;
    }
    time.minutes = time.minutes + minutes;
    if (time.minutes >= 60) {
        time.hours = time.hours + 1;
        time.minutes = time.minutes - 60;
    }
    time.hours = (time.hours % 24);
    return time;
}

CG_INLINE IDLTime IDLTimeAddHours(IDLTime time, NSInteger hours)
{
    while (hours < 0) {
        hours += 480;
    }
    time.hours = ((time.hours + hours) % 24);
    return time;
}

CG_INLINE IDLTime IDLTimeMake(NSInteger hours, NSInteger minutes, NSInteger seconds)
{
    IDLTime t; t.hours = hours; t.minutes = minutes; t.seconds = seconds;
    return t;
}

CG_INLINE NSComparisonResult IDLTimeCompare(IDLTime t1, IDLTime t2)
{
    NSInteger t1AfterMidnight = IDLTimeSecondsAfterMidnight(t1);
    NSInteger t2AfterMidnight = IDLTimeSecondsAfterMidnight(t2);
    
    if (t1AfterMidnight < t2AfterMidnight) {
        return NSOrderedAscending;
    } else if (t1AfterMidnight > t2AfterMidnight) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
    
}

#pragma mark - IDLFloatRange

CG_INLINE IDLFloatRange IDLMakeFloatRange(CGFloat loc, CGFloat len)
{
    IDLFloatRange r;
    r.location = loc;
    r.length = len;
    return r;
}

CG_INLINE CGFloat IDLMaxFloatRange(IDLFloatRange range)
{
    return (range.location + range.length);
}

CG_INLINE BOOL IDLLocationInFloatRange(CGFloat loc, IDLFloatRange range)
{
    return (!(loc < range.location) && (loc - range.location) < range.length) ? YES : NO;
}

CG_INLINE BOOL IDLEqualFloatRanges(IDLFloatRange range1, IDLFloatRange range2)
{
    return (range1.location == range2.location && range1.length == range2.length);
}

CG_INLINE IDLFloatRange IDLUnionFloatRange(IDLFloatRange range1, IDLFloatRange range2)
{
    CGFloat max = MAX(IDLMaxFloatRange(range1), IDLMaxFloatRange(range2));
    IDLFloatRange r;
    r.location = MIN(range1.location, range2.location);
    r.length = max - r.location;
    return r;
}

CG_INLINE IDLFloatRange IDLIntersectionFloatRange(IDLFloatRange range1, IDLFloatRange range2)
{
    IDLFloatRange r;
    CGFloat range1Max = IDLMaxFloatRange(range1);
    CGFloat range2Max = IDLMaxFloatRange(range2);
    if (range1.location < range2Max && range2.location < range1Max) {
        r.location = MAX(range1.location, range2.location);
        r.length = MIN(range1Max, range2Max) - r.location;
    } else {
        r.length = 0.0f;
    }
    
    if (r.length <= 0.0f) {
        r.location = NAN;
    }
    
    return r;
}

CG_INLINE NSString *NSStringFromIDLFloatRange(IDLFloatRange range)
{
    return [NSString stringWithFormat:@"{%e, %e}", range.location, range.length];
}

CG_INLINE IDLFloatRange IDLFloatRangeFromNSString(NSString *aString)
{
    BOOL success = aString.length > 0;
    IDLFloatRange r;
    if (success) {
        aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
        aString = [aString stringByReplacingOccurrencesOfString:@"," withString:@" "];
        NSScanner *scanner = [NSScanner scannerWithString:aString];
        double location = 0.0f;
        double length = 0.0f;
        success = [scanner scanDouble:&location] && [scanner scanDouble:&length];
        if (success) {
            r.location = location;
            r.length = length;
        }
    }
    if (!success) {
        r.location = NAN;
        r.length = 0.0f;
    }
    return r;
}

#endif
