#import "AESSivWrapper.h"
#import "siv.h"

#define IVLength AES_BLOCK_SIZE

@implementation AESSivWrapper

+ (nullable NSData *)AESSivDecrptData:(NSData *_Nonnull )data key:(NSData *_Nonnull )key {
    NSAssert(!([data length] < (IVLength + 1)), @"Invalid data provided");
    @try {
        
        siv_ctx siv;
        unsigned char* SIV_KEYS = (unsigned char*) [key bytes];
        
        NSData* iv = [data subdataWithRange:NSMakeRange(0, IVLength)];//first 16 bytes of encrypted data
        NSData* cipher = [data subdataWithRange:NSMakeRange(IVLength, [data length]-IVLength)];//cipher data
        unsigned char* firmware = (unsigned char*) [cipher bytes];
        
        int rc = siv_init(&siv, SIV_KEYS, SIV_256);
        if (rc != 1) {
            #ifdef DEBUG
                NSLog(@"Failed to init siv");
            #endif
        }
        unsigned char decryptedFirmware[[cipher length]];
        unsigned char* IVC = (unsigned char*)[iv bytes];
        siv_decrypt(&siv, firmware, decryptedFirmware, (int)[cipher length],IVC,0);
        NSData* decryptedData = [NSData dataWithBytes:(const void* )decryptedFirmware length:sizeof(decryptedFirmware)];
        
        return decryptedData;
        
    } @catch (NSException *exception) {
        #ifdef DEBUG
            NSLog(@"Unable to do AES SIV Decrypt in function: %s exception:%@", __func__, exception.reason);
        #endif
    }
}
@end
