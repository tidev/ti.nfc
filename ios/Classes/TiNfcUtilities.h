//
//  TiNfcUtilities.h
//  ti.nfc
//
//  Created by Hans Knöchel on 28.06.17.
//

#if IS_DEVICE && defined(IS_XCODE_9)

#import <Foundation/Foundation.h>
#import <CoreNFC/CoreNFC.h>

@interface TiNfcUtilities : NSObject

+ (NSArray<NSDictionary<NSString *, id> *> *)arrayFromNDEFMessages:(NSArray<NFCNDEFMessage *> *)messages;

+ (NSArray<NSDictionary<NSString *, id> *> *)arrayFromNDEFPayloads:(NSArray<NFCNDEFPayload *> *)payloads;

@end

#endif
