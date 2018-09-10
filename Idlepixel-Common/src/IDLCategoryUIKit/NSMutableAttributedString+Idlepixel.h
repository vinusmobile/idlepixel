//
//  NSMutableAttributedString+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (IDLReplace)

-(void)replaceOccurrences:(NSString *)string withAttributedString:(NSAttributedString *)attrString;
-(void)replaceOccurrences:(NSString *)string withAttributedString:(NSAttributedString *)attrString options:(NSStringCompareOptions)options;

- (void)setAttributes:(NSDictionary *)attrs forOccurrences:(NSString *)string;
- (void)setAttributes:(NSDictionary *)attrs forOccurrences:(NSString *)string options:(NSStringCompareOptions)options;
@end
