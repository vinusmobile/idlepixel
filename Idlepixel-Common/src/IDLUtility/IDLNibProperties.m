//
//  IDLNibProperties.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLNibProperties.h"
#import "NSMutableDictionary+Idlepixel.h"
#import "IDLCommonMacros.h"
#import "UIColor+Idlepixel.h"

@interface IDLNibProperties ()

@property (nonatomic, readwrite, assign) UIViewContentMode contentMode;
@property (nonatomic, readwrite, assign) NSInteger tag;
@property (nonatomic, readwrite, assign) CGRect frame;
@property (nonatomic, readwrite, strong) UIColor *backgroundColor;
@property (nonatomic, readwrite, assign) BOOL userInteractionEnabled;
@property (nonatomic, readwrite, assign) BOOL multipleTouchEnabled;
@property (nonatomic, readwrite, assign) CGFloat alpha;
@property (nonatomic, readwrite, assign) BOOL opaque;
@property (nonatomic, readwrite, assign) BOOL hidden;
@property (nonatomic, readwrite, assign) BOOL clearsContextBeforeDrawing;
@property (nonatomic, readwrite, assign) BOOL clipsToBounds;
@property (nonatomic, readwrite, assign) BOOL autoresizesSubviews;
@property (nonatomic, readwrite, assign) UIViewAutoresizing autoresizingMask;
@property (nonatomic, readwrite, assign) BOOL loaded;

@end

@implementation IDLNibProperties

+ (IDLNibProperties *)nibPropertiesForNibLoadedView:(UIView *)view
{
    IDLNibProperties *properties = [IDLNibProperties new];
    properties.contentMode = view.contentMode;
    properties.tag = view.tag;
    properties.frame = view.frame;
    properties.backgroundColor = view.backgroundColor;
    properties.userInteractionEnabled = view.userInteractionEnabled;
    properties.multipleTouchEnabled = view.multipleTouchEnabled;
    properties.alpha = view.alpha;
    properties.opaque = view.opaque;
    properties.hidden = view.hidden;
    properties.clearsContextBeforeDrawing = view.clearsContextBeforeDrawing;
    properties.clipsToBounds = view.clipsToBounds;
    properties.autoresizesSubviews = view.autoresizesSubviews;
    properties.autoresizingMask = view.autoresizingMask;
    return properties;
}

+ (IDLNibProperties *)nibPropertiesFromDictonary:(NSDictionary *)dictionary
{
    if (dictionary) {
        return [[IDLNibProperties alloc] initWithDictonary:dictionary];
    } else {
        return nil;
    }
}

- (id)initWithDictonary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _contentMode = [dictionary integerForKey:ObjectToNSString(_contentMode)];
        _tag = [dictionary integerForKey:ObjectToNSString(_tag)];
        _frame = [dictionary rectForKey:ObjectToNSString(_frame)];
        _backgroundColor = UIColorFromNSData([dictionary dataForKey:ObjectToNSString(_backgroundColor)]);
        _userInteractionEnabled = [dictionary boolForKey:ObjectToNSString(_userInteractionEnabled)];
        _multipleTouchEnabled = [dictionary boolForKey:ObjectToNSString(_multipleTouchEnabled)];
        _alpha = [dictionary floatForKey:ObjectToNSString(_alpha)];
        _opaque = [dictionary boolForKey:ObjectToNSString(_opaque)];
        _hidden = [dictionary boolForKey:ObjectToNSString(_hidden)];
        _clearsContextBeforeDrawing = [dictionary boolForKey:ObjectToNSString(_clearsContextBeforeDrawing)];
        _clipsToBounds = [dictionary boolForKey:ObjectToNSString(_clipsToBounds)];
        _autoresizesSubviews = [dictionary boolForKey:ObjectToNSString(_autoresizesSubviews)];
        _autoresizingMask = [dictionary integerForKey:ObjectToNSString(_autoresizingMask)];
        _loaded = [dictionary boolForKey:ObjectToNSString(_loaded)];
    }
    return self;
}

-(NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setInteger:_contentMode forKey:ObjectToNSString(_contentMode)];
    [dictionary setInteger:_tag forKey:ObjectToNSString(_tag)];
    [dictionary setRect:_frame forKey:ObjectToNSString(_frame)];
    [dictionary setObject:NSDataFromUIColor(_backgroundColor) forKey:ObjectToNSString(_backgroundColor)];
    [dictionary setBool:_userInteractionEnabled forKey:ObjectToNSString(_userInteractionEnabled)];
    [dictionary setBool:_multipleTouchEnabled forKey:ObjectToNSString(_multipleTouchEnabled)];
    [dictionary setFloat:_alpha forKey:ObjectToNSString(_alpha)];
    [dictionary setBool:_opaque forKey:ObjectToNSString(_opaque)];
    [dictionary setBool:_hidden forKey:ObjectToNSString(_hidden)];
    [dictionary setBool:_clearsContextBeforeDrawing forKey:ObjectToNSString(_clearsContextBeforeDrawing)];
    [dictionary setBool:_clipsToBounds forKey:ObjectToNSString(_clipsToBounds)];
    [dictionary setBool:_autoresizesSubviews forKey:ObjectToNSString(_autoresizesSubviews)];
    [dictionary setInteger:_autoresizingMask forKey:ObjectToNSString(_autoresizingMask)];
    [dictionary setBool:_loaded forKey:ObjectToNSString(_loaded)];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
