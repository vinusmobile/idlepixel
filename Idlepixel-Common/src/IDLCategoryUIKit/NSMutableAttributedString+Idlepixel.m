//
//  NSMutableAttributedString+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "NSMutableAttributedString+Idlepixel.h"
#import "NSString+Idlepixel.h"

@implementation NSMutableAttributedString (IDLReplace)

-(void)replaceOccurrences:(NSString *)string withAttributedString:(NSAttributedString *)attrString
{
    [self replaceOccurrences:string withAttributedString:attrString options:0];
}

-(void)replaceOccurrences:(NSString *)string withAttributedString:(NSAttributedString *)attrString options:(NSStringCompareOptions)options
{
    if (string.length > 0) {
        options = options | NSBackwardsSearch;
        NSRange searchRange = self.string.range;
        NSRange range;
        while ((range = [self.string rangeOfString:string options:options range:searchRange]).location != NSNotFound) {
            [self replaceCharactersInRange:range withAttributedString:attrString];
            searchRange.location = 0;
            searchRange.length = range.location;
        }
    }
}

- (void)setAttributes:(NSDictionary *)attrs forOccurrences:(NSString *)string
{
    [self setAttributes:attrs forOccurrences:string options:0];
}

- (void)setAttributes:(NSDictionary *)attrs forOccurrences:(NSString *)string options:(NSStringCompareOptions)options
{
    if (string.length > 0) {
        options = options | NSBackwardsSearch;
        NSRange searchRange = self.string.range;
        NSRange range;
        while ((range = [self.string rangeOfString:string options:options range:searchRange]).location != NSNotFound) {
            [self setAttributes:attrs range:range];
            searchRange.location = 0;
            searchRange.length = range.location;
        }
    }
}

@end
