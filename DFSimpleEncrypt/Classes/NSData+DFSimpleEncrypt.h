//
//  NSData+DFSimpleEncrypt.h
//  Encrypt
//
//  Created by dan on 19/12/2012.
//  Copyright (c) 2012 dan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DFSimpleEncrypt)

//This only needs adding once as it can be applied to plainText to encrypt (+ key) and applied to cryptText (+key) to decode.
+(NSData *)xorEncrypt:(NSData *)data WithKey:(NSString *)key;

-(NSData *)xorEncryptWithKey:(NSString *)key;
//This methods will return a new NSData with encrypted/decrypted text (CString)
-(NSData *)uuEncode;
-(NSData *)uuDecode;

//Some *string* methods added for ease of use.
-(NSString *)uuEncodeToString;
-(NSString *)returnString;

@end
