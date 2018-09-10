//
//  NSData+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 1/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSData+Idlepixel.h"
#import <CommonCrypto/CommonDigest.h>
#include <zlib.h>

#define kHeaderBytesImageJPEG   "\xff\xd8\xff"
#define kHeaderBytesImagePNG    "\x89\x50\x4e\x47"
#define kHeaderBytesImageGIF    "\x47\x49\x46"
#define kHeaderBytesImageBMP    "\x42\x4d"
#define kHeaderBytesGZip        "\x1f\x8b\x08"

#define kHeaderLengthImageJPEG  3
#define kHeaderLengthImagePNG   4
#define kHeaderLengthImageGIF   3
#define kHeaderLengthImageBMP   2
#define kHeaderLengthGZip       3

@implementation NSData (IDLHeaderBytes)

-(BOOL)hasHeaderBytes:(NSData *)headerBytes
{
    if (headerBytes.length == 0) {
        return YES;
    } else if (self.length < headerBytes.length) {
        return NO;
    } else {
        NSRange range = [self rangeOfData:headerBytes options:NSDataSearchAnchored range:NSMakeRange(0, headerBytes.length)];
        return (range.location == 0);
    }
}

@end

@implementation NSData (IDLImageType)

-(BOOL)isJPEG
{
    return [self hasHeaderBytes:[NSData dataWithBytes:kHeaderBytesImageJPEG length:kHeaderLengthImageJPEG]];
}

-(BOOL)isPNG
{
    return [self hasHeaderBytes:[NSData dataWithBytes:kHeaderBytesImagePNG length:kHeaderLengthImagePNG]];
}

-(BOOL)isGIF
{
    return [self hasHeaderBytes:[NSData dataWithBytes:kHeaderBytesImageGIF length:kHeaderLengthImageGIF]];
}

-(BOOL)isBMP
{
    return [self hasHeaderBytes:[NSData dataWithBytes:kHeaderBytesImageBMP length:kHeaderLengthImageBMP]];
}

@end

@implementation NSData (IDLCRC32)

- (uint32_t)CRC32
{
    uLong crc = crc32(0L, Z_NULL, 0);
    crc = crc32(crc, self.bytes, (uInt)self.length);
    return (uint32_t)crc;
}

@end

@implementation NSData (IDLHash)

- (NSString*)md5Hash {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (uInt)self.length, result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return [ret lowercaseString];
}

@end

// copied and modified from http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html

@implementation NSData (IDLGZip)

- (NSData *)gzipInflate
{
	if ([self length] == 0) return self;
	
	if (![self isGZip]) {
		return self;
	} else {
		uLong full_length = [self length];
		uLong half_length = [self length] / 2;
		
		NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
		BOOL done = NO;
		int status;
		
		z_stream strm;
		strm.next_in = (Bytef *)[self bytes];
		strm.avail_in = (uInt)self.length;
		strm.total_out = 0;
		strm.zalloc = Z_NULL;
		strm.zfree = Z_NULL;
		
		if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
		while (!done) {
			// Make sure we have enough room and reset the lengths.
			if (strm.total_out >= [decompressed length])
				[decompressed increaseLengthBy: half_length];
			strm.next_out = decompressed.mutableBytes + strm.total_out;
			strm.avail_out = (uInt)(decompressed.length - strm.total_out);
			
			// Inflate another chunk.
			status = inflate (&strm, Z_SYNC_FLUSH);
			if (status == Z_STREAM_END) done = YES;
			else if (status != Z_OK) break;
		}
		if (inflateEnd (&strm) != Z_OK) return nil;
		
		// Set real length.
		if (done) {
			[decompressed setLength: strm.total_out];
			return [NSData dataWithData: decompressed];
		}
		else return nil;
	}
}

- (NSData *)gzipDeflate
{
	if ([self length] == 0) return self;
	
	z_stream strm;
	
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.total_out = 0;
	strm.next_in=(Bytef *)[self bytes];
	strm.avail_in = (uInt)self.length;
	
	// Compresssion Levels:
	//   Z_NO_COMPRESSION
	//   Z_BEST_SPEED
	//   Z_BEST_COMPRESSION
	//   Z_DEFAULT_COMPRESSION
	
	if (deflateInit2(&strm, Z_BEST_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
	
	NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
	
	do {
		if (strm.total_out >= [compressed length])
			[compressed increaseLengthBy: 16384];
		
		strm.next_out = compressed.mutableBytes + strm.total_out;
		strm.avail_out = (uInt)(compressed.length - strm.total_out);
		
		deflate(&strm, Z_FINISH);
		
	} while (strm.avail_out == 0);
	
	deflateEnd(&strm);
	
	[compressed setLength: strm.total_out];
	return [NSData dataWithData:compressed];
}

- (BOOL)isGZip
{
    return [self hasHeaderBytes:[NSData dataWithBytes:kHeaderBytesGZip length:kHeaderLengthGZip]];
}

@end