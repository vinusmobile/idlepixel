//
//  IDLModelObjectProtocols.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 9/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDLDictionaryRepresentation <NSObject>

@required
+ (NSSet *)dictionaryRepresentationKeys;
- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;
- (NSDictionary *)dictionaryRepresentation:(BOOL)plistConformant;
- (NSDictionary *)plistRepresentation;

@end

@protocol IDLPersistentModelObject <IDLDictionaryRepresentation, NSCoding>

@end

@protocol IDLCacheableModelObject <NSObject>

@required
-(void)clearCache;

@end

@protocol IDLUniqueKeyedObject <NSObject>

@required
-(NSObject<NSCopying> *)uniqueKey;

@end

@protocol IDLUniqueKeyedObjectCollection <NSObject>

@required
-(BOOL)maintainUniqueCollection;

@end