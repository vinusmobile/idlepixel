//
//  IDLImageData.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLImageData.h"
#import "NSData+Idlepixel.h"
#import "NSMutableDictionary+Idlepixel.h"

@interface IDLImageData ()

@end

@implementation IDLImageData

+(IDLImageData *)dataWithImage:(UIImage *)anImage
{
    return [[IDLImageData alloc] initWithImage:anImage];
}

+(IDLImageData *)dataWithCGImage:(CGImageRef)CGImage
{
    return [[IDLImageData alloc] initWithCGImage:CGImage];
}

+(IDLImageData *)dataWithCGImage:(CGImageRef)CGImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    return [[IDLImageData alloc] initWithCGImage:CGImage scale:scale orientation:orientation];
}

-(id)initWithImage:(UIImage *)anImage
{
    self = [self initWithCGImage:anImage.CGImage scale:anImage.scale orientation:anImage.imageOrientation];
    return self;
}

-(id)initWithCGImage:(CGImageRef)CGImage
{
    self = [self initWithCGImage:CGImage scale:1.0f orientation:UIImageOrientationUp];
    return self;
}

-(id)initWithCGImage:(CGImageRef)CGImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    CGDataProviderRef provider = CGImageGetDataProvider(CGImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(CGImage);
    CFDataRef cfdata = CGDataProviderCopyData(provider);
    NSData *data = [NSData dataWithData:(__bridge_transfer NSData*)cfdata];
    
    self = [self init];
    if (self) {
        self.data = data;
        self.width = CGImageGetWidth(CGImage);
        self.height = CGImageGetHeight(CGImage);
        self.bitsPerComponent = CGImageGetBitsPerComponent(CGImage);
        self.bitsPerPixel = CGImageGetBitsPerPixel(CGImage);
        self.bytesPerRow = CGImageGetBytesPerRow(CGImage);
        self.colorSpaceModel = CGColorSpaceGetModel(colorSpace);
        self.bitmapInfo = CGImageGetBitmapInfo(CGImage);
        self.shouldInterpolate = CGImageGetShouldInterpolate(CGImage);
        self.renderingIntent = CGImageGetRenderingIntent(CGImage);
        self.scale = scale;
        self.imageOrientation = orientation;
    }
    return self;
}

- (UIImage *)UIImage
{
    CGColorSpaceRef colorSpace = nil;
    
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelMonochrome:
            colorSpace = CGColorSpaceCreateDeviceGray();
            break;
        case kCGColorSpaceModelRGB:
            colorSpace = CGColorSpaceCreateDeviceRGB();
            break;
        case kCGColorSpaceModelCMYK:
            colorSpace = CGColorSpaceCreateDeviceCMYK();
            break;
        default:
            colorSpace = nil;
            break;
    }
    if (colorSpace != nil) {
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)self.data);
        CGImageRef cg = CGImageCreate(self.width,
                                           self.height,
                                           self.bitsPerComponent,
                                           self.bitsPerPixel,
                                           self.bytesPerRow,
                                           colorSpace,
                                           self.bitmapInfo,
                                           provider,
                                           nil,
                                           self.shouldInterpolate,
                                           self.renderingIntent);
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpace);
        UIImage *image = [UIImage imageWithCGImage:cg scale:self.scale orientation:self.imageOrientation];
        CGImageRelease(cg);
        return image;
    } else {
        NSLog(@"Error: unrecognized colorspace.");
        return nil;
    }
}

- (NSUInteger)length
{
    return self.data.length;
}

#pragma mark NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    IDLImageData *copy = [[IDLImageData alloc] init];
    copy.data = self.data;
    copy.width = self.width;
    copy.height = self.height;
    copy.bitsPerComponent = self.bitsPerComponent;
    copy.bitsPerPixel = self.bitsPerPixel;
    copy.bytesPerRow = self.bytesPerRow;
    copy.colorSpaceModel = self.colorSpaceModel;
    copy.bitmapInfo = self.bitmapInfo;
    copy.shouldInterpolate = self.shouldInterpolate;
    copy.renderingIntent = self.renderingIntent;
    copy.scale = self.scale;
    copy.imageOrientation = self.imageOrientation;
    return copy;
}


#pragma mark NSSecureCoding

#define kImageDataCoderKeyData                  @"data"
#define kImageDataCoderKeyWidth                 @"width"
#define kImageDataCoderKeyHeight                @"height"
#define kImageDataCoderKeyBitsPerComponent      @"bitsPerComponent"
#define kImageDataCoderKeyBitsPerPixel          @"bitsPerPixel"
#define kImageDataCoderKeyBytesPerRow           @"bytesPerRow"
#define kImageDataCoderKeyColorspaceModel       @"colorspaceModel"
#define kImageDataCoderKeyBitmapInfo            @"bitmapInfo"
#define kImageDataCoderKeyShouldInterpolate     @"shouldInterpolate"
#define kImageDataCoderKeyRenderingIntent       @"renderingIntent"
#define kImageDataCoderKeyScale                 @"scale"
#define kImageDataCoderKeyImageOrientation      @"imageOrientation"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.data forKey:kImageDataCoderKeyData];
    [aCoder encodeInt64:self.width forKey:kImageDataCoderKeyWidth];
    [aCoder encodeInt64:self.height forKey:kImageDataCoderKeyHeight];
    [aCoder encodeInt64:self.bitsPerComponent forKey:kImageDataCoderKeyBitsPerComponent];
    [aCoder encodeInt64:self.bitsPerPixel forKey:kImageDataCoderKeyBitsPerPixel];
    [aCoder encodeInt64:self.bytesPerRow forKey:kImageDataCoderKeyBytesPerRow];
    [aCoder encodeInt64:self.colorSpaceModel forKey:kImageDataCoderKeyColorspaceModel];
    [aCoder encodeInt64:self.bitmapInfo forKey:kImageDataCoderKeyBitmapInfo];
    [aCoder encodeBool:self.shouldInterpolate forKey:kImageDataCoderKeyShouldInterpolate];
    [aCoder encodeInt64:self.renderingIntent forKey:kImageDataCoderKeyRenderingIntent];
    [aCoder encodeFloat:self.scale forKey:kImageDataCoderKeyScale];
    [aCoder encodeInt64:self.imageOrientation forKey:kImageDataCoderKeyImageOrientation];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.data = [aDecoder decodeObjectOfClass:[NSData class] forKey:kImageDataCoderKeyData];
        self.width = [aDecoder decodeInt64ForKey:kImageDataCoderKeyWidth];
        self.height = [aDecoder decodeInt64ForKey:kImageDataCoderKeyHeight];
        self.bitsPerComponent = [aDecoder decodeInt64ForKey:kImageDataCoderKeyBitsPerComponent];
        self.bitsPerPixel = [aDecoder decodeInt64ForKey:kImageDataCoderKeyBitsPerPixel];
        self.bytesPerRow = [aDecoder decodeInt64ForKey:kImageDataCoderKeyBytesPerRow];
        self.colorSpaceModel = [aDecoder decodeInt32ForKey:kImageDataCoderKeyColorspaceModel];
        self.bitmapInfo = [aDecoder decodeInt32ForKey:kImageDataCoderKeyBitmapInfo];
        self.shouldInterpolate = [aDecoder decodeBoolForKey:kImageDataCoderKeyShouldInterpolate];
        self.renderingIntent = [aDecoder decodeInt32ForKey:kImageDataCoderKeyRenderingIntent];
        self.scale = [aDecoder decodeFloatForKey:kImageDataCoderKeyScale];
        self.imageOrientation = [aDecoder decodeInt64ForKey:kImageDataCoderKeyImageOrientation];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark IDLDictionaryRepresentation

+ (NSSet *)dictionaryRepresentationKeys
{
    return [NSSet setWithObjects:kImageDataCoderKeyData,
            kImageDataCoderKeyWidth,
            kImageDataCoderKeyHeight,
            kImageDataCoderKeyBitsPerComponent,
            kImageDataCoderKeyBitsPerPixel,
            kImageDataCoderKeyBytesPerRow,
            kImageDataCoderKeyColorspaceModel,
            kImageDataCoderKeyBitmapInfo,
            kImageDataCoderKeyShouldInterpolate,
            kImageDataCoderKeyRenderingIntent,
            kImageDataCoderKeyScale,
            kImageDataCoderKeyImageOrientation, nil];
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    self = [self init];
    if (self) {
        self.data = [dictionary dataForKey:kImageDataCoderKeyData];
        self.width = [dictionary integerForKey:kImageDataCoderKeyWidth];
        self.height = [dictionary integerForKey:kImageDataCoderKeyHeight];
        self.bitsPerComponent = [dictionary integerForKey:kImageDataCoderKeyBitsPerComponent];
        self.bitsPerPixel = [dictionary integerForKey:kImageDataCoderKeyBitsPerPixel];
        self.bytesPerRow = [dictionary integerForKey:kImageDataCoderKeyBytesPerRow];
        self.colorSpaceModel = [dictionary intForKey:kImageDataCoderKeyColorspaceModel];
        self.bitmapInfo = [dictionary intForKey:kImageDataCoderKeyBitmapInfo];
        self.shouldInterpolate = [dictionary boolForKey:kImageDataCoderKeyShouldInterpolate];
        self.renderingIntent = [dictionary intForKey:kImageDataCoderKeyRenderingIntent];
        self.scale = [dictionary floatForKey:kImageDataCoderKeyScale];
        self.imageOrientation = [dictionary integerForKey:kImageDataCoderKeyImageOrientation];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    return [self dictionaryRepresentation:NO];
}

- (NSDictionary *)dictionaryRepresentation:(BOOL)plistConformant
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.data forKey:kImageDataCoderKeyData];
    [dictionary setInteger:self.width forKey:kImageDataCoderKeyWidth];
    [dictionary setInteger:self.height forKey:kImageDataCoderKeyHeight];
    [dictionary setInteger:self.bitsPerComponent forKey:kImageDataCoderKeyBitsPerComponent];
    [dictionary setInteger:self.bitsPerPixel forKey:kImageDataCoderKeyBitsPerPixel];
    [dictionary setInteger:self.bytesPerRow forKey:kImageDataCoderKeyBytesPerRow];
    [dictionary setInt:self.colorSpaceModel forKey:kImageDataCoderKeyColorspaceModel];
    [dictionary setInt:self.bitmapInfo forKey:kImageDataCoderKeyBitmapInfo];
    [dictionary setBool:self.shouldInterpolate forKey:kImageDataCoderKeyShouldInterpolate];
    [dictionary setInt:self.renderingIntent forKey:kImageDataCoderKeyRenderingIntent];
    [dictionary setFloat:self.scale forKey:kImageDataCoderKeyScale];
    [dictionary setInteger:self.imageOrientation forKey:kImageDataCoderKeyImageOrientation];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)plistRepresentation
{
    return [self dictionaryRepresentation:YES];
}

@end
