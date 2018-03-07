//
//  WXSecKeyBoardUtils.m
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/6.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import "WXSecKeyBoardUtils.h"
#import <openssl/rsa.h>
#import <openssl/bio.h>
#import <openssl/evp.h>
#import <openssl/pem.h>

#define HOMEPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define PRIVATEKEYNAME @"WXSecKeyPriKey.key"

#define PRIVATEKEYPATH [[NSString stringWithFormat:@"%@/%@",HOMEPATH,PRIVATEKEYNAME] UTF8String]

#define WXSecKeyBoardRSAPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKQ5hq8cXWpiTp1XjH3ADppSEFbq2RTkzrPKwjTGvqMnX8t3mtDmVIdX7szWqV5407fb920sEjW5Rhoq379G1wcKC/f+6oNKGwP7Uc5hKM7xcwEjEetkgGT+5mjX4XpxXgi0Zxm8ecQt3WkM7v6q5TAW5vnNrD+MRh4SjRk7fbxzAgMBAAECgYEAk/ymysvDvmciMpU/K95TCmtjAAAXaMWbItdW1Fo4VivYHjEEmLTGfUQXFA1oiJJXLzqQJ5fsPO9dJZ13DRXYE7Tj/+6ngwufUwalUzkJ+34tLTygrisTkwXImjrJuMDfH4DQ2KlQfLo86jQ5JKH4X8HLJu9GWCPE9S+vjIh5PkECQQDWokKHEktCphF4/wG1TYbNIvicIxhIMXrfxrtvwDQGibZHvctAvpqMtXnaxbc2jzrEk5/2bwjPjApc54L0KjghAkEAw+AmNGStG2ZNMox2JbB+vOc3VuHO4pz+EH24f3A6B7yLQzcBLz9RPNvq36Er6AS3fCk9VVQT/BM8OV6QlkFSEwJBANKL75kSwBNMVz2LYgCZYZAgKyL3Zl2DdFbKW5pfQGndc5tiulzz3SYE69lJNNXnoS2u5y9Wcp0ucgf670JXnCECQFLa3A5Jj9gJPBpnxApJUDMD8yqzNdox4l6Db6mohUOEg7wY5k1gETMXK5EREguBA0RoBWO0vwdf85eo4qxMUTUCQA/wMNeJMkpVAEJCjuH4Q+HsFoQP5U2suwDnAJX1ypUOB6+nLxYZdo67Na56zais0zGSSf4GkdtSbmEIyjowlXg="

@implementation WXSecKeyBoardUtils

+ (int)initializePrivate:(NSString *)key
{
    NSMutableString * result = [NSMutableString string];
    
    if(key == nil)
    {
        key = WXSecKeyBoardRSAPrivateKey;
    }
    const char * pstr = [key UTF8String];
    
    [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
    
    int index = 0;
    int count = 0;
    int len = (int)[key length];
    while(index < len)
    {
        char ch = pstr[index];
        if(ch == '\r' || ch == '\n')
        {
            ++index;
            continue;
        }
        [result appendFormat:@"%c",ch];
        
        if(++count == 79)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END PRIVATE KEY-----"];
    
    NSString * keyPath = [HOMEPATH stringByAppendingPathComponent:PRIVATEKEYNAME];
    if([[NSFileManager defaultManager] fileExistsAtPath:keyPath])
    {
        return -1;
    }
    
    char * ptr = (char *)[result UTF8String];
    
//    for(int i = 0; i < result.length;i++)
//    {
//        ptr[i] = ~(ptr[i]);
//    }
    
    int fd = open([keyPath UTF8String], O_WRONLY | O_CREAT,0677);
    
    if(fd == -1)
    {
        perror("open");
        close(fd);
        return -1;
    }
    
    if(write(fd, ptr, strlen(ptr)) == -1)
    {
        perror("write");
        close(fd);
        return -1;
    }
    
    return 0;
}

+ (int)initializPublicKey:(NSString *)pubKey
{
    NSMutableString * result = [NSMutableString string];
    
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    
    int index = 0;
    int count = 0;
    while(index < pubKey.length)
    {
        if([pubKey characterAtIndex:index] == '\r' || [pubKey characterAtIndex:index] == '\n')
        {
            continue;
        }
        
        [result appendFormat:@"%c",[pubKey characterAtIndex:index]];
        
        if(++count == 76)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        
        index++;
    }
    
    [result appendString:@"\n-----END PUBLIC KEY-----"];
    
    NSString * pubKeyPath = [NSString stringWithFormat:@"%@/WXPublicKey.key",HOMEPATH];
    if([[NSFileManager defaultManager] fileExistsAtPath:pubKeyPath])
    {
        return -1;
    }
    
    int fd = open([pubKeyPath UTF8String], O_RDWR | O_CREAT,0677);
    if(fd == -1)
    {
        perror("open");
        return -1;
    }
    
    unsigned char * inputbuffer = (unsigned char *)[result UTF8String];
    int inputbuffersize = (int)result.length;
    
    if(write(fd, inputbuffer, inputbuffersize) == -1)
    {
        perror("write");
        close(fd);
        return -1;
    }
    close(fd);
    return 0;
    
}

+ (NSString *)getPrivateKey
{
    NSString * priKey = [NSString string];
    
    NSString * keyPath = [NSString stringWithFormat:@"%@/%@",HOMEPATH,PRIVATEKEYNAME];
    int fd = open([keyPath UTF8String], O_RDONLY);
    if(fd == -1)
    {
        perror("open");
        close(fd);
        return nil;
    }
    unsigned char loadput = 0;
    while(read(fd, &loadput, 1) > 0)
    {
        priKey = [priKey stringByAppendingFormat:@"%c",loadput];
        
    }
    return priKey;
}


+ (void)removeHomeKeyPath
{
    NSString * keyPath = [NSString stringWithFormat:@"%@/%@",HOMEPATH,PRIVATEKEYNAME];
    NSString * pubkeyPath = [NSString stringWithFormat:@"%@/WXPublicKey.key",HOMEPATH];
    unlink([keyPath UTF8String]);
    unlink([pubkeyPath UTF8String]);
}

+ (NSString *)encryptRSA:(NSString *)content
{
    NSMutableString * encrypt = nil;
    
    FILE * file = fopen(PRIVATEKEYPATH, "r");
    if(file == NULL)
    {
        perror("fopen");
        return nil;
    }
    
    RSA * rsa;
    
    rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
    if(rsa == NULL)
    {
        perror("PEM_read_RSAPrivateKey");
        return nil;
    }
    
    unsigned char * outputbuffer = (unsigned char *)malloc(RSA_size(rsa)+1);
    memset(outputbuffer, 0x0, RSA_size(rsa)+1);
    
    if(RSA_private_encrypt(RSA_size(rsa),(unsigned const char *)[content UTF8String],outputbuffer,rsa,RSA_NO_PADDING) == -1)
    {
        perror("RSA_private_encrypt");
        encrypt = nil;
        goto ret;
    }
    {
        NSData *data = [NSData dataWithBytes:outputbuffer length:RSA_size(rsa)];
        data = [data base64EncodedDataWithOptions:0];
        encrypt = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
//    for(int i = 0;i < RSA_size(rsa);i++)
//    {
//        [encrypt appendFormat:@"%02X",outputbuffer[i]];
//    }
    
ret:
    free(outputbuffer);
    outputbuffer = NULL;
    fclose(file);
    
    return encrypt;
}

+ (NSString *)decryptRSA:(NSString *)encrypt
{
    NSMutableString * decrypt = [NSMutableString string];
    
    NSString * pubKeyPath = [NSString stringWithFormat:@"%@/WXPublicKey.key",HOMEPATH];
    
    FILE * file = fopen([pubKeyPath cStringUsingEncoding:NSASCIIStringEncoding], "r");
    
    unsigned char *encryptData = NULL;
    
    //hextochar([encrypt UTF8String], encryptData, encrypt.length, 16);
    encryptData = (unsigned char *)[[[NSData alloc] initWithBase64EncodedString:encrypt options:NSDataBase64DecodingIgnoreUnknownCharacters] bytes];
    
    if(file == NULL)
    {
        perror("fopen");
        return nil;
    }
    
    RSA * rsa;
    
    rsa = PEM_read_RSA_PUBKEY(file,NULL,NULL,NULL);
    if(rsa == NULL)
    {
        perror("PEM_read_RSA_PUBKEY");
        fclose(file);
        return nil;
    }
    
    int flen = RSA_size(rsa);
    
    unsigned char * outputbuffer = (unsigned char *)malloc(flen + 1);
    
    if(RSA_public_decrypt(flen,encryptData,outputbuffer,rsa,RSA_NO_PADDING) == -1)
    {
        perror("RSA_public_decrypt");
        free(outputbuffer);
        outputbuffer = NULL;
        fclose(file);
        return nil;
    }
    
    [decrypt appendFormat:@"%s",outputbuffer];
    free(outputbuffer);
    outputbuffer = NULL;
    fclose(file);
    
    return decrypt;
}

static void hextochar(const char * input,unsigned char * output,int size,int base)
{
    while(isxdigit(*input) && size--)
    {
        *output++ = base * (isxdigit(*input) ? *input++ - '0' : tolower(*input++) - 'a' + 10) + (isxdigit(*input) ? *input++ - '0' : tolower(*input++) - 'a' + 10);
    }
}

@end
