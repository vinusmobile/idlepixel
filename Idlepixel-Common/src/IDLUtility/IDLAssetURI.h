//
//  IDLAssetURI.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 12/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDLAssetProtocol <NSObject>

@required
-(NSSet *)assetURIs;

@end

@interface IDLAssetURI : NSObject

@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *sourceIdentifier;

+(IDLAssetURI *)assetURI:(NSString *)uri withSourceIdentifier:(NSString *)sourceIdentifier;
-(id)initWithURI:(NSString *)uri withSourceIdentifier:(NSString *)sourceIdentifier;

@end

@interface IDLAssetObjectHelper : NSObject

+(NSSet *)assetURIsInSet:(NSSet *)aSet;
+(NSSet *)assetURIsInSet:(NSSet *)aSet existingAssetURIs:(NSSet *)existingAssetURIs;
+(NSSet *)unionAssetURIs:(NSSet *)assetURIs moreAssetURIs:(NSSet *)moreAssetURIs;
+(NSSet *)addAssetURI:(NSString *)assetURI withSourceIdentifier:(NSString *)sourceIdentifier toAssetURIs:(NSSet *)existingAssetURIs;
+(NSSet *)makeAssetURISet:(NSString *)assetURI withSourceIdentifier:(NSString *)sourceIdentifier;
+(NSSet *)assetURIsWithSourceIdentifier:(NSString *)sourceIdentifier inAssetURISet:(NSSet *)aSet;

@end
