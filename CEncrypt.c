//
//  CEncrypt.c
//  Encrypt
//
//  Created by dan on 19/12/2012.
//  Copyright (c) 2012 dan. All rights reserved.
//

#include "CEncrypt.h"
#include <string.h>

/* C DEFINES */


#define UUDECODE(c) (c=='`' ? 0 : c - ' ')
#define N64(i) (i & ~63)

#define UUENCODE_LENGTH 45
#define UUDECODE_LENGTH 61 //40% overhead from using UUENCODE

const char uudigit[64] =
{
    '`', '!', '"', '#', '$', '%', '&', '\'',
    '(', ')', '*', '+', ',', '-', '.', '/',
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', ':', ';', '<', '=', '>', '?',
    '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
    'X', 'Y', 'Z', '[', '\\', ']', '^', '_'
};



char* xor_data(char* input_data, const char* key, unsigned long length)
{
    //unsigned long data_length = strlen(input_data);
    char *output_data = strdup(input_data);
    int key_count = 0; //Used to restart key if strlen(key) < strlen(encrypt)
    for (long i = 0; i < length; i ++)
    {
        //XOR the data and write it to a file
        *(output_data+i) = (*(output_data+i) ^ key[key_count]);
        //Incrrement key_count and start over if necessary
        key_count++;
        if(key_count == strlen(key))
            key_count = 0;
    }
    return output_data;
}


int touufrombits(unsigned char *out, const unsigned char *in, long inlen)
{
    int len;
    
    if (inlen > 45) return -1;
    len = (inlen * 4 + 2) / 3 + 1;
    *out++ = uudigit[inlen];
    
    for (; inlen >= 3; inlen -= 3) {
        *out++ = uudigit[in[0] >> 2];
        *out++ = uudigit[((in[0] << 4) & 0x30) | (in[1] >> 4)];
        *out++ = uudigit[((in[1] << 2) & 0x3c) | (in[2] >> 6)];
        *out++ = uudigit[in[2] & 0x3f];
        in += 3;
    }
    
    if (inlen > 0) {
        *out++ = uudigit[(in[0] >> 2)];
        if (inlen == 1) {
            *out++ = uudigit[((in[0] << 4) & 0x30)];
        } else {
            *out++ = uudigit[(((in[0] << 4) & 0x30) | (in[1] >> 4))] ;
            *out++ = uudigit[((in[1] << 2) & 0x3c)];
        }
    }
    *out = '\0';
    
    return len;
}

int fromuutobits(char *out, const char *in)
{
    int len, outlen, inlen;
    register unsigned char digit1, digit2;
    
    outlen = UUDECODE(in[0]);
    in += 1;
    if(outlen < 0 || outlen > 45)
        return -2;
    if(outlen == 0)
        return 0;
    inlen = (outlen * 4 + 2) / 3;
    len = 0;
    
    for( ; inlen>0; inlen-=4) {
        digit1 = UUDECODE(in[0]);
        if (N64(digit1))
            return -1;
        digit2 = UUDECODE(in[1]);
        if (N64(digit2))
            return -1;
        out[len++] = (digit1 << 2) | (digit2 >> 4);
        if (inlen > 2) {
            digit1 = UUDECODE(in[2]);
            if (N64(digit1))
                return -1;
            out[len++] = (digit2 << 4) | (digit1 >> 2);
            if (inlen > 3) {
                digit2 = UUDECODE(in[3]);
                if (N64(digit2))
                    return -1;
                out[len++] = (digit1 << 6) | digit2;
            }
        }
        in += 4;
    }
    
    return len == outlen ? len : -3;
}