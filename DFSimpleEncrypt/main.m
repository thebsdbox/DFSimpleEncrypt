//
//  main.m
//  Encrypt
//
//  Created by dan on 16/11/2012.
//  Copyright (c) 2012 dan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+DFSimpleEncrypt.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        // Sample raw data
        NSData *testData = [NSData dataWithBytes:"1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" length:100];
        // XOR encrypt with key
        NSData *encryptedData = [testData xorEncryptWithKey:@"@£%$£"];
        // XOR Decrypt with same key
        encryptedData = [encryptedData xorEncryptWithKey:@"@£%$£"];
        // Display de-crypted data
        NSLog(@"%@",[encryptedData returnString]);
        // UUEncode
        encryptedData = [encryptedData uuEncode];
        //Display encrypted string
        NSLog(@"%@",[encryptedData returnString]);
        //UUDecode
        encryptedData = [encryptedData uuDecode];
        //Displaye decrypted string
        NSLog(@"%@",[encryptedData returnString]);
    }
    return 0;
}