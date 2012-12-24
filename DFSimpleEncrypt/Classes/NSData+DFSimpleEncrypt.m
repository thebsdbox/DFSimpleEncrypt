//
//  NSData+DFSimpleEncrypt.m
//  Encrypt
//
//  Created by dan on 19/12/2012.
//  Copyright (c) 2012 dan. All rights reserved.
//

#import "NSData+DFSimpleEncrypt.h"
#import "CEncrypt.h"


@implementation NSData (DFSimpleEncrypt)

+(NSData *)xorEncrypt:(NSData *)data WithKey:(NSString *)key {
    char *bytes = malloc(sizeof(char) * [data length]);
    [data getBytes:bytes length:data.length];
    NSData *result = [NSData dataWithBytes:xor_data(bytes, [key UTF8String], [data length]) length:[data length]];
    free(bytes);
    return  result;
}

-(NSData *)xorEncryptWithKey:(NSString *)key {
    if (sizeof(id) == [self length]) {
        // Basically only 8 bytes have been allocated, meaning possible pointer
        // Check to see if the contents of NSData are the same size as an NSObject pointer
        [self checkContents];
    }
    char *bytes = malloc(sizeof(char) * [self length]);
    [self getBytes:bytes length:[self length]];
    //char *encryptionData = xor_data(bytes, [key UTF8String], [self length]);
    NSData *result = [NSData dataWithBytes:xor_data(bytes, [key UTF8String], [self length]) length:[self length]];
    free(bytes);
    return result;
}

-(BOOL)checkContents {

        NSLog(@"Possible object added to NSData");

    return false;
}


-(NSData *)uuEncode {
    // Allocate character array adjusted for extra characters needed to UU encoding
    char *uuEncryptedData = malloc((([self length])* 4 + 2) / 3 + 1);
    NSMutableData *mutableEncryption = [NSMutableData data];
    unsigned long dataLength = [self length];
    int len = 0;
    // Loop through the data and encode in amounts of 45, or what ever is remaining if less than 45
    for (unsigned long readPointer = 0; readPointer < dataLength; readPointer += 45) {
        unsigned long rangeLength= 45;
        if (dataLength < len) {
            rangeLength = dataLength;
        }
        else {
            if (rangeLength+readPointer > dataLength) {
                rangeLength = (dataLength - readPointer);
            }
        }
        len = touufrombits((unsigned char *)uuEncryptedData,(unsigned const char *)[[self subdataWithRange:NSMakeRange(readPointer, rangeLength)] bytes], rangeLength);
        [mutableEncryption appendBytes:uuEncryptedData length:len];        
    }
    // Free up the malloc'd memory
    free(uuEncryptedData);
    // Possibly use -copy and return an immutable array?
    return mutableEncryption;
}

-(NSData *)uuDecode {
    char *uuEncryptedData = malloc([self length]);
    NSMutableData *mutableEncryption = [[NSMutableData alloc] init];
    unsigned long dataLength = [self length];
    for (unsigned long readPointer = 0; readPointer < dataLength; readPointer += 61) {
        unsigned long rangeLength= 61;
        if (dataLength < 61) {
            rangeLength = dataLength;
        }
        else {
            if (rangeLength+readPointer > dataLength) {
                rangeLength = (dataLength - readPointer);
            }
        }
        memset(uuEncryptedData,0,dataLength);
        int len = fromuutobits((char *)uuEncryptedData,(const char *)[[self subdataWithRange:NSMakeRange(readPointer, rangeLength)] bytes]);
        if ( len == -1)
            return [NSData dataWithBytes:@"Error Processing" length:17];
        [mutableEncryption appendBytes:uuEncryptedData length:len];
        
    }
    // Free up the malloc'd memory
    free(uuEncryptedData);
    return mutableEncryption;
}

-(NSString *)uuEncodeToString {
    // In theory this should be a null terminated string.
    return [NSString stringWithCString:[[self uuEncode] bytes] encoding:NSUTF8StringEncoding];
}

-(NSString *)returnString {
    // Cut out the correct length, and null terminate.
    return [NSString stringWithCString:[[self subdataWithRange:NSMakeRange(0, [self length])] bytes] encoding:NSUTF8StringEncoding];
}

@end
