//
//  NSString+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 1/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSString+Idlepixel.h"
#import "NSData+Idlepixel.h"
#import "IDLLoggingMacros.h"
#import "IDLNSInlineExtensions.h"

@implementation NSString (IDLHash)

- (NSString*)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

@end

@implementation NSString (IDLPadding)

+(NSString *)stringByLooping:(NSString *)aString toLength:(NSUInteger)length
{
    if (aString.length == 0) {
        return @"";
    } else if (length <= aString.length) {
        return [aString substringWithRange:NSMakeRange(0,length)];
    } else {
        NSMutableString *output = aString.mutableCopy;
        while (output.length < length) {
            if ((output.length + aString.length) <= length) {
                [output appendString:aString];
            } else {
                NSInteger subLength = length - (output.length + aString.length);
                [output appendString:[aString substringToIndex:subLength]];
            }
        }
        return [NSString stringWithString:output];
    }
}

-(NSString *)stringByLoopingToLength:(NSUInteger)length
{
    return [NSString stringByLooping:self toLength:length];
}

+(NSString *)stringByLooping:(NSString *)aString iterationCount:(NSUInteger)count
{
    return [NSString stringByLooping:aString toLength:(count * aString.length)];
}

-(NSString *)stringByLoopingIterationCount:(NSUInteger)count
{
    return [self stringByLoopingToLength:(count * self.length)];
}

-(NSString *)stringByRepeatingCharacters:(NSUInteger)count
{
    if (count == 0) {
        return [NSString string];
    } else if (count == 1 || self.length == 0) {
        return [self copy];
    } else {
        NSMutableString *string = [NSMutableString string];
        NSString *characterString;
        for (NSUInteger i = 0; i < self.length; i++) {
            characterString = [NSString stringByLooping:[NSString stringWithFormat:@"%C",[self characterAtIndex:i]] iterationCount:count];
            [string appendString:characterString];
        }
        return [NSString stringWithString:string];
    }
}

@end

@implementation NSString (IDLCharacters)

-(NSString *)firstCharacter
{
    if (self.length > 0) {
        return [self substringToIndex:1];
    } else {
        return nil;
    }
}

@end

@implementation NSString (IDLCharactersRange)

-(NSRange)range
{
    return NSMakeRange(0, self.length);
}

- (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aSet
{
    return [self rangeOfCharactersFromSet:aSet options:0];
}

- (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask
{
    return [self rangeOfCharactersFromSet:aSet options:mask range:self.range];
}

- (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
    //IDLLogContext(@"looking in \"%@\", with range %@",self,NSStringFromRange(searchRange));
    NSRange range = [self rangeOfCharacterFromSet:aSet options:mask range:searchRange];
    if (range.location != NSNotFound) {
        NSRange searchRange = NSMakeRange(range.location+1, self.length-(range.location+1));
        NSRange realRange = range;
        NSInteger offset;
        //IDLLogContext(@"first: %@",NSStringFromRange(range));
        do {
            offset = searchRange.location;
            searchRange = [self rangeOfCharacterFromSet:aSet options:mask range:searchRange];
            //IDLLogContext(@"search result: %@",NSStringFromRange(searchRange));
            if (searchRange.location == offset) {
                realRange.length = realRange.length + 1;
                searchRange.location = searchRange.location + 1;
                searchRange.length = self.length-searchRange.location;
            } else {
                searchRange.location = NSNotFound;
            }
            //IDLLogContext(@"new searchrange: %@",NSStringFromRange(searchRange));
            //IDLLogContext(@"realRange: %@",NSStringFromRange(realRange));
        } while (searchRange.location != NSNotFound && searchRange.length > 0);
        range = realRange;
        //IDLLogContext(@"searchrange: %@",NSStringFromRange(searchRange));
        //IDLLogContext(@"final range: %@",NSStringFromRange(realRange));
        //do {
        //} while (endRange.location == )
    }
    return range;
}

- (NSRange)rangeOfSequenceBeginningWithString:(NSString *)beginningString finishingString:(NSString *)finishingString
{
    return [self rangeOfSequenceBeginningWithString:beginningString finishingString:finishingString options:0];
}

- (NSRange)rangeOfSequenceBeginningWithString:(NSString *)beginningString finishingString:(NSString *)finishingString options:(NSStringCompareOptions)mask
{
    return [self rangeOfSequenceBeginningWithString:beginningString finishingString:finishingString options:mask range:self.range];
}

- (NSRange)rangeOfSequenceBeginningWithString:(NSString *)beginningString finishingString:(NSString *)finishingString options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
    NSRange beginRange = [self rangeOfString:beginningString options:mask range:searchRange];
    if (beginRange.location != NSNotFound) {
        NSRange endRange = NSMakeRange(NSRangeGetMax(beginRange), 0);
        endRange.length = NSRangeGetMax(searchRange)-endRange.location;
        if (endRange.length > 0) {
            endRange = [self rangeOfString:finishingString options:mask range:endRange];
            if (endRange.location != NSNotFound) {
                return NSMakeRange(beginRange.location, NSRangeGetMax(endRange)-beginRange.location);
            }
        }
    }
    return NSMakeRange(NSNotFound, 0);
}

- (NSRange)rangeOfSequenceBeginningWithCharacterFromSet:(NSCharacterSet *)beginningSet finishingSet:(NSCharacterSet *)finishingSet
{
    return [self rangeOfSequenceBeginningWithCharacterFromSet:beginningSet finishingSet:finishingSet options:0];
}

- (NSRange)rangeOfSequenceBeginningWithCharacterFromSet:(NSCharacterSet *)beginningSet finishingSet:(NSCharacterSet *)finishingSet options:(NSStringCompareOptions)mask
{
    return [self rangeOfSequenceBeginningWithCharacterFromSet:beginningSet finishingSet:finishingSet options:mask range:self.range];
}

- (NSRange)rangeOfSequenceBeginningWithCharacterFromSet:(NSCharacterSet *)beginningSet finishingSet:(NSCharacterSet *)finishingSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
    NSRange beginRange = [self rangeOfCharacterFromSet:beginningSet options:mask range:searchRange];
    if (beginRange.location != NSNotFound) {
        NSRange endRange = NSMakeRange(NSRangeGetMax(beginRange), 0);
        endRange.length = NSRangeGetMax(searchRange)-endRange.location;
        if (endRange.length > 0) {
            endRange = [self rangeOfCharacterFromSet:finishingSet options:mask range:endRange];
            if (endRange.location != NSNotFound) {
                return NSMakeRange(beginRange.location, NSRangeGetMax(endRange)-beginRange.location);
            }
        }
    }
    return NSMakeRange(NSNotFound, 0);
}

- (BOOL)containsCharacterFromSet:(NSCharacterSet *)aSet
{
    return [self containsCharacterFromSet:aSet options:0];
}

- (BOOL)containsCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask
{
    return [self containsCharacterFromSet:aSet options:mask range:self.range];
}

- (BOOL)containsCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
    NSRange range = [self rangeOfCharacterFromSet:aSet options:mask range:searchRange];
    return (range.location != NSNotFound);
}

- (BOOL)containsString:(NSString *)aString
{
    return [self containsString:aString options:0];
}

- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask
{
    return [self containsString:aString options:mask range:self.range];
}

- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
    NSRange range = [self rangeOfString:aString options:mask range:searchRange];
    return (range.location != NSNotFound);
}

- (BOOL)containsCaseInsensitiveString:(NSString *)aString
{
    return [self containsString:aString options:NSCaseInsensitiveSearch];
}

@end

@implementation NSString (IDLStripCharacters)

-(NSString *)stringByStrippingCharactersInSet:(NSCharacterSet *)characterSet
{
    if (characterSet != nil) {
        NSInteger length = 0;
        unichar strippedString[self.length];
        unichar buffer;
        for (NSUInteger i = 0; i < self.length; i++) {
            buffer = [self characterAtIndex:i];
            if (![characterSet characterIsMember:buffer]) {
                strippedString[length] = buffer;
                length++;
            }
        }
        return [NSString stringWithCharacters:strippedString length:length];
    } else {
        return [NSString stringWithString:self];
    }
}

-(NSString *)stringByStrippingCharactersNotInSet:(NSCharacterSet *)characterSet
{
    if (characterSet != nil) {
        return [self stringByStrippingCharactersInSet:[characterSet invertedSet]];
    } else {
        return [NSString string];
    }
}

@end

@implementation NSString (IDLPercentValue)

-(CGFloat)percentValue
{
    NSString *s = [self stringByStrippingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([s hasSuffix:@"%"]) {
        return ([s floatValue]/100.0f);
    } else {
        return [s floatValue];
    }
}

@end

@implementation NSString (IDLSuffixPrefix)

-(NSString *)stringByRemovingSuffix:(NSString *)suffix
{
    return [self stringByRemovingPrefix:nil suffix:suffix];
}

-(NSString *)stringByRemovingPrefix:(NSString *)prefix
{
    return [self stringByRemovingPrefix:prefix suffix:nil];
}

-(NSString *)stringByAddingPrefix:(NSString *)prefix
{
    NSString *result = nil;
    if (prefix != nil) {
        result = [NSString stringWithFormat:@"%@%@", prefix, self];
    } else {
        result = [NSString stringWithString:self];
    }
    return result;
}

-(NSString *)stringByAddingPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    if (prefix != nil && suffix == nil) {
        return [self stringByAddingPrefix:prefix];
    } else if (prefix == nil && suffix != nil) {
        return [self stringByAppendingString:suffix];
    } else {
        return [NSString stringWithFormat:@"%@%@%@", prefix, self, suffix];
    }
}

-(NSString *)stringByAddingPrefix:(NSString *)prefix appendingString:(NSString *)string
{
    return [self stringByAddingPrefix:prefix suffix:string];
}

-(NSString *)stringByRemovingPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    NSRange range = self.range;
    if (prefix != nil && [self hasPrefix:prefix]) {
        range.location = prefix.length;
        range.length = range.length - range.location;
    }
    if (suffix != nil && [self hasSuffix:suffix]) {
        range.length = range.length - suffix.length;
    }
    return [self substringWithRange:range];
}

-(NSArray *)componentsSeparatedByString:(NSString *)separator prefix:(NSString *)prefix suffix:(NSString *)suffix
{
    if ([self hasPrefix:prefix] && [self hasSuffix:suffix]) {
        NSString *parts = [self stringByRemovingPrefix:prefix suffix:suffix];
        return [parts componentsSeparatedByString:separator];
    }
    return nil;
}

@end

@implementation NSString (IDLURLEncoding)

- (NSString *)URLEncodedString
{
    NSString *result = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end

@implementation NSString (IDLCaseInsensitive)

-(BOOL)isEqualToCaseInsensitiveString:(NSString *)aString
{
    if (self == aString) {
        return YES;
    } else if (aString == nil) {
        return NO;
    } else {
        return ([self compare:aString options:NSCaseInsensitiveSearch] == NSOrderedSame);
    }
}

@end

@implementation NSString (IDLLoremIpsum)

+(NSArray *)loremIpsumWordsArray
{
    return @[@"lorem", @"ipsum", @"dolor", @"sit", @"amet", @"consectetur", @"adipisicing", @"elit", @"sed", @"do", @"eiusmod", @"tempor", @"incididunt", @"ut", @"labore", @"et", @"dolore", @"magna", @"aliqua", @"ut", @"enim", @"ad", @"minim", @"veniam", @"quis", @"nostrud", @"exercitation", @"ullamco", @"laboris", @"nisi", @"ut", @"aliquip", @"ex", @"ea", @"commodo", @"consequat", @"Duis", @"aute", @"irure", @"dolor", @"in", @"reprehenderit", @"in", @"voluptate", @"velit", @"esse", @"cillum", @"dolore", @"eu", @"fugiat", @"nulla", @"pariatur", @"excepteur", @"sint", @"occaecat", @"cupidatat", @"non", @"proident", @"sunt", @"in", @"culpa", @"qui", @"officia", @"deserunt", @"mollit", @"anim", @"id", @"est", @"laborum"];
}

#define kStringPeriod   @"."
#define kStringComma    @","

NS_INLINE NSString *NSStringRandomPunctuationElement()
{
    NSArray *punct = @[kStringPeriod, kStringComma];
    return [punct objectAtIndex:(rand()%2)];
}

+(NSString *)stringWithLoremIpsumWords:(NSUInteger)count
{
    NSArray *words = [self loremIpsumWordsArray];
    NSMutableArray *result = [NSMutableArray array];
    unsigned long offset = random() / words.count;
    BOOL capitalise = YES;
    for (int ii = 0; ii < count; ii++) {
        NSString *word = [words objectAtIndex:(ii + offset) % words.count];
        if (capitalise) {
            word = [word capitalizedString];
            capitalise = NO;
        }
        if (randf() > 0.95) {
            NSString *punctuation = NSStringRandomPunctuationElement();
            if (NSStringEquals(punctuation, kStringPeriod)) capitalise = YES;
            word = [word stringByAppendingString:punctuation];
        }
        [result addObject:word];
    }
    return [result componentsJoinedByString:@" "];
}

+(NSString *)stringWithLoremIpsumParagraphs:(NSUInteger)count
{
    NSMutableArray *paras = [NSMutableArray arrayWithCapacity:count];
    for (int ii = 0; ii < count; ii++) {
        NSString *paragraph = [self stringWithLoremIpsumWords:(8 + (rand() % 20))];
        paragraph = [paragraph stringByRemovingSuffix:kStringComma];
        if (![paragraph hasSuffix:kStringPeriod]) paragraph = [paragraph stringByAppendingString:kStringPeriod];
        [paras addObject:paragraph];
    }
    return [paras componentsJoinedByString:@"\n\n"];
}

@end

@implementation NSString (IDLOrdinalSuffix)

#define kStringOrdinalSuffixTH  @"th"
#define kStringOrdinalSuffixST  @"st"
#define kStringOrdinalSuffixND  @"nd"
#define kStringOrdinalSuffixRD  @"rd"

+(NSString *)ordinalSuffixForInteger:(NSUInteger)integer
{
    integer = integer % 100;
    if (integer > 10 && integer < 20) {
        return kStringOrdinalSuffixTH;
    } else {
        integer = integer % 10;
        switch (integer) {
            case 1:
                return kStringOrdinalSuffixST;
            case 2:
                return kStringOrdinalSuffixND;
            case 3:
                return kStringOrdinalSuffixRD;
            default:
                return kStringOrdinalSuffixTH;
        }
    }
}

@end

@implementation NSString (IDLUniversalUniqueID)

+(NSString *)universalUniqueID
{
	CFUUIDRef	uuidObj = CFUUIDCreate(kCFAllocatorDefault);
	NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
	CFRelease(uuidObj);
	return uuidString;
}

@end

@implementation NSString (IDLFilenameDateString)

+(NSString *)filenameDateStringFromDate:(NSDate *)date
{
    NSString *filename = nil;
    
    if (date != nil) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat: @"yyyy-MM-dd HHmmssSSS"];
        filename = [formatter stringFromDate:date];
    } else {
        filename = @"_unknown_";
    }
    return filename;
}

@end


