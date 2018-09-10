//
//  IDLAssetURI.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 12/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLAssetURI.h"
#import "NSString+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

@implementation IDLAssetURI

+(IDLAssetURI *)assetURI:(NSString *)uri withSourceIdentifier:(NSString *)sourceIdentifier
{
    return [[self alloc] initWithURI:uri withSourceIdentifier:sourceIdentifier];
}

-(id)initWithURI:(NSString *)uri withSourceIdentifier:(NSString *)sourceIdentifier
{
    self = [self init];
    if (self) {
        self.uri = uri;
        self.sourceIdentifier = sourceIdentifier;
    }
    return self;
}

#define kHashOffset         5754853343l
#define kHashMultiplier     2860486313l

-(NSUInteger)hash
{
    NSUInteger hash = (self.uri.hash + kHashOffset) * kHashMultiplier;
    hash = hash << self.sourceIdentifier.hash;
    return hash;
}

-(BOOL)isEqual:(id)object
{
    BOOL e = [super isEqual:object];
    if (e && [object isKindOfClass:[self class]]) {
        IDLAssetURI *assetObject = (IDLAssetURI *)object;
        return NSStringEquals(assetObject.sourceIdentifier, self.sourceIdentifier) && NSStringEquals(assetObject.uri, self.uri);
    } else {
        return NO;
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"IDLAssetURI(%@)[%@]",self.sourceIdentifier,self.uri];
}

@end

@implementation IDLAssetObjectHelper

+(NSSet *)assetURIsInSet:(NSSet *)aSet
{
    if ([aSet count] > 0) {
        NSMutableSet *mutableAssetURIs = [NSMutableSet set];
        NSSet *childAssetURIs = nil;
        @synchronized (aSet) {
            for (NSObject *object in [aSet copy]) {
                if ([object conformsToProtocol:@protocol(IDLAssetProtocol)]) {
                    id<IDLAssetProtocol> assetObject = (id<IDLAssetProtocol>)object;
                    childAssetURIs = [assetObject assetURIs];
                    if ([childAssetURIs count] > 0) {
                        [mutableAssetURIs unionSet:childAssetURIs];
                    }
                }
                if ([object isKindOfClass:[IDLAssetURI class]]) {
                    [mutableAssetURIs addObject:object];
                }
            }
        }
        if ([mutableAssetURIs count] > 0) {
            return [NSSet setWithSet:mutableAssetURIs];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+(NSSet *)assetURIsInSet:(NSSet *)aSet existingAssetURIs:(NSSet *)existingAssetURIs
{
    NSSet *assetURIs = [self assetURIsInSet:aSet];
    return [self unionAssetURIs:assetURIs moreAssetURIs:existingAssetURIs];
}

+(NSSet *)unionAssetURIs:(NSSet *)assetURIs moreAssetURIs:(NSSet *)moreAssetURIs
{
    if (assetURIs == moreAssetURIs) {
        return assetURIs;
    } else if ([assetURIs count] > 0 && [moreAssetURIs count] > 0) {
        return [assetURIs setByAddingObjectsFromSet:moreAssetURIs];
    } else if ([assetURIs count] > 0) {
        return assetURIs;
    } else {
        return moreAssetURIs;
    }
}

+(NSSet *)addAssetURI:(NSString *)assetURI withSourceIdentifier:(NSString *)sourceIdentifier toAssetURIs:(NSSet *)existingAssetURIs;
{
    if (assetURI != nil) {
        IDLAssetURI *asset = [IDLAssetURI assetURI:assetURI withSourceIdentifier:sourceIdentifier];
        if ([existingAssetURIs count] > 0) {
            existingAssetURIs = [existingAssetURIs setByAddingObject:asset];
        } else {
            existingAssetURIs = [NSSet setWithObject:asset];
        }
    }
    return existingAssetURIs;
}

+(NSSet *)makeAssetURISet:(NSString *)assetURI withSourceIdentifier:(NSString *)sourceIdentifier;
{
    return [self addAssetURI:assetURI withSourceIdentifier:sourceIdentifier toAssetURIs:nil];
}

+(NSSet *)assetURIsWithSourceIdentifier:(NSString *)sourceIdentifier inAssetURISet:(NSSet *)aSet;
{
    if (aSet == nil) {
        return nil;
    } else if (aSet.count == 0) {
        return [NSSet set];
    } else {
        aSet = [NSSet setWithSet:aSet];
        NSMutableSet *result = [NSMutableSet set];
        for (IDLAssetURI *asset in aSet) {
            if (NSStringEquals(sourceIdentifier, asset.sourceIdentifier)) {
                [result addObject:asset];
            }
        }
        return [NSSet setWithSet:result];
    }
}

@end
