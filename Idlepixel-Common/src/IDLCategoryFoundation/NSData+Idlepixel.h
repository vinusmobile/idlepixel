//
//  NSData+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 1/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (IDLHeaderBytes)

- (BOOL)hasHeaderBytes:(NSData *)headerBytes;

@end

@interface NSData (IDLImageType)

@property (nonatomic, readonly) BOOL isJPEG;
@property (nonatomic, readonly) BOOL isPNG;
@property (nonatomic, readonly) BOOL isGIF;
@property (nonatomic, readonly) BOOL isBMP;

@end

@interface NSData (IDLCRC32)

@property (nonatomic, readonly) uint32_t CRC32;

@end

@interface NSData (IDLHash)

@property (nonatomic, readonly) NSString* md5Hash;

@end

@interface NSData (IDLGZip)

@property (nonatomic, readonly) NSData *gzipInflate;
@property (nonatomic, readonly) NSData *gzipDeflate;

@property (nonatomic, readonly) BOOL isGZip;

@end

