//
//  IDLImageData.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLModelObjectProtocols.h"

@interface IDLImageData : NSObject <NSSecureCoding, NSCopying, IDLDictionaryRepresentation>

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) size_t width;
@property (nonatomic, assign) size_t height;
@property (nonatomic, assign) size_t bitsPerComponent;
@property (nonatomic, assign) size_t bitsPerPixel;
@property (nonatomic, assign) size_t bytesPerRow;
@property (nonatomic, assign) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, assign) CGBitmapInfo bitmapInfo;
@property (nonatomic, assign) BOOL shouldInterpolate;
@property (nonatomic, assign) CGColorRenderingIntent renderingIntent;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) UIImageOrientation imageOrientation;

@property (nonatomic, readonly) NSUInteger length;

+ (IDLImageData *)dataWithImage:(UIImage *)anImage;
+ (IDLImageData *)dataWithCGImage:(CGImageRef)CGImage;
+ (IDLImageData *)dataWithCGImage:(CGImageRef)CGImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

- (id)initWithImage:(UIImage *)anImage;
- (id)initWithCGImage:(CGImageRef)CGImage;
- (id)initWithCGImage:(CGImageRef)CGImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

- (UIImage *)UIImage;

@end
