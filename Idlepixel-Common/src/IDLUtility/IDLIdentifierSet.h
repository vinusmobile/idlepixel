//
//  IDLIdentifierSet.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/02/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_INLINE NSString* IDLIdentifierWithPrefix(NSString *identifier, NSString *prefix)
{
    if (prefix) {
        return [NSString stringWithFormat:@"«⎨%@⎬∩⎨%@⎬»",prefix,identifier];
    } else {
        return identifier;
    }
}

@interface IDLIdentifierSet : NSObject

+(instancetype)setWithIdentifiers:(NSSet *)identifiers;
-(id)initWithIdentifiers:(NSSet *)identifiers;

-(BOOL)containsIdentifier:(NSString *)identifier;
-(BOOL)containsIdentifier:(NSString *)identifier prefix:(NSString *)prefix;

-(void)addIdentifier:(NSString *)identifier;
-(void)addIdentifier:(NSString *)identifier prefix:(NSString *)prefix;
-(void)addIdentifiers:(NSSet *)identifiers;
-(void)addIdentifiers:(NSSet *)identifiers prefix:(NSString *)prefix;

-(void)removeIdentifier:(NSString *)identifier;
-(void)removeIdentifier:(NSString *)identifier prefix:(NSString *)prefix;
-(void)removeIdentifiers:(NSSet *)identifiers;
-(void)removeIdentifiers:(NSSet *)identifiers prefix:(NSString *)prefix;

-(BOOL)removeIdentifiersNotInSet:(NSSet *)validIdentifiers;

-(BOOL)toggleIdentifier:(NSString *)identifier;
-(BOOL)toggleIdentifier:(NSString *)identifier prefix:(NSString *)prefix;
-(void)toggleIdentifiers:(NSSet *)identifiers;
-(void)toggleIdentifiers:(NSSet *)identifiers prefix:(NSString *)prefix;

@property (readonly) NSUInteger count;
@property (assign) NSSet *identifiers;

@end
