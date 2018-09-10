//
//  IDLNibProperties.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDLNibProperties : NSObject

@property (nonatomic, readonly, assign) UIViewContentMode contentMode;
@property (nonatomic, readonly, assign) NSInteger tag;
@property (nonatomic, readonly, assign) CGRect frame;
@property (nonatomic, readonly, strong) UIColor *backgroundColor;
@property (nonatomic, readonly, assign) BOOL userInteractionEnabled;
@property (nonatomic, readonly, assign) BOOL multipleTouchEnabled;
@property (nonatomic, readonly, assign) CGFloat alpha;
@property (nonatomic, readonly, assign) BOOL opaque;
@property (nonatomic, readonly, assign) BOOL hidden;
@property (nonatomic, readonly, assign) BOOL clearsContextBeforeDrawing;
@property (nonatomic, readonly, assign) BOOL clipsToBounds;
@property (nonatomic, readonly, assign) BOOL autoresizesSubviews;
@property (nonatomic, readonly, assign) UIViewAutoresizing autoresizingMask;
@property (nonatomic, readonly, assign) BOOL loaded;

@property (readonly) NSDictionary *dictionaryRepresentation;

+ (IDLNibProperties *)nibPropertiesForNibLoadedView:(UIView *)view;
+ (IDLNibProperties *)nibPropertiesFromDictonary:(NSDictionary *)dictionary;

- (id)initWithDictonary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
