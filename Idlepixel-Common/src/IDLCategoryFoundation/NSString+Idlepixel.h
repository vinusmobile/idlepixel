//
//  NSString+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 1/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IDLHash)

@property (nonatomic, readonly) NSString* md5Hash;

@end

@interface NSString (IDLPadding)

+(NSString *)stringByLooping:(NSString *)aString toLength:(NSUInteger)length;
+(NSString *)stringByLooping:(NSString *)aString iterationCount:(NSUInteger)count;

-(NSString *)stringByLoopingToLength:(NSUInteger)length;
-(NSString *)stringByLoopingIterationCount:(NSUInteger)count;

-(NSString *)stringByRepeatingCharacters:(NSUInteger)count;

@end

@interface NSString (IDLCharacters)

@property (readonly) NSString *firstCharacter;

@end

@interface NSString (IDLCharactersRange)

@property (nonatomic, readonly) NSRange range;

- (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aSet;
- (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask;
- (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange;

- (NSRange)rangeOfSequenceBeginningWithString:(NSString *)beginningString finishingString:(NSString *)finishingString;
- (NSRange)rangeOfSequenceBeginningWithCharacterFromSet:(NSCharacterSet *)beginningSet finishingSet:(NSCharacterSet *)finishingSet;

- (NSRange)rangeOfSequenceBeginningWithString:(NSString *)beginningString finishingString:(NSString *)finishingString options:(NSStringCompareOptions)mask;
- (NSRange)rangeOfSequenceBeginningWithCharacterFromSet:(NSCharacterSet *)beginningSet finishingSet:(NSCharacterSet *)finishingSet options:(NSStringCompareOptions)mask;

- (NSRange)rangeOfSequenceBeginningWithString:(NSString *)beginningString finishingString:(NSString *)finishingString options:(NSStringCompareOptions)mask range:(NSRange)searchRange;
- (NSRange)rangeOfSequenceBeginningWithCharacterFromSet:(NSCharacterSet *)beginningSet finishingSet:(NSCharacterSet *)finishingSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange;

- (BOOL)containsCharacterFromSet:(NSCharacterSet *)aSet;
- (BOOL)containsCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask;
- (BOOL)containsCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange;
- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask;
- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange;

- (BOOL)containsCaseInsensitiveString:(NSString *)aString;

@end

@interface NSString (IDLStripCharacters)

-(NSString *)stringByStrippingCharactersInSet:(NSCharacterSet *)characterSet;
-(NSString *)stringByStrippingCharactersNotInSet:(NSCharacterSet *)characterSet;

@end

@interface NSString (IDLPercentValue)

@property (nonatomic, readonly) CGFloat percentValue;

@end

@interface NSString (IDLSuffixPrefix)

-(NSString *)stringByRemovingSuffix:(NSString *)suffix;
-(NSString *)stringByRemovingPrefix:(NSString *)prefix;

-(NSString *)stringByAddingPrefix:(NSString *)prefix;
-(NSString *)stringByAddingPrefix:(NSString *)prefix suffix:(NSString *)suffix;
-(NSString *)stringByAddingPrefix:(NSString *)prefix appendingString:(NSString *)string;

-(NSString *)stringByRemovingPrefix:(NSString *)prefix suffix:(NSString *)suffix;
-(NSArray *)componentsSeparatedByString:(NSString *)separator prefix:(NSString *)prefix suffix:(NSString *)suffix;

@end

@interface NSString (IDLURLEncoding)

- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString;

@end

@interface NSString (IDLCaseInsensitive)

-(BOOL)isEqualToCaseInsensitiveString:(NSString *)aString;

@end

@interface NSString (IDLLoremIpsum)

+(NSArray *)loremIpsumWordsArray;

+(NSString *)stringWithLoremIpsumWords:(NSUInteger)count;
+(NSString *)stringWithLoremIpsumParagraphs:(NSUInteger)count;

@end

@interface NSString (IDLOrdinalSuffix)

+(NSString *)ordinalSuffixForInteger:(NSUInteger)integer;

@end

@interface NSString (IDLUniversalUniqueID)

+(NSString *)universalUniqueID;

@end

NS_INLINE NSString* NSStringUniversalUniqueID()
{
    return [NSString universalUniqueID];
}

@interface NSString (IDLFilenameDateString)

+(NSString *)filenameDateStringFromDate:(NSDate *)date;

@end
