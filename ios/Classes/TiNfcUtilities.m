//
//  TiNfcUtilities.m
//  ti.nfc
//
//  Created by Hans Knöchel on 28.06.17.
//

#if IS_DEVICE && defined(IS_XCODE_9)

#import "TiNfcUtilities.h"
#import "TiBlob.h"

@implementation TiNfcUtilities

+ (NSArray<NSDictionary<NSString *, id> *> *)arrayFromNDEFMessages:(NSArray<NFCNDEFMessage *> *)messages;
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:messages.count];
    
    for (NFCNDEFMessage *message in messages) {
        [result addObject:@{
            @"records": [TiNfcUtilities arrayFromNDEFPayloads:message.records]
        }];
    }
    
    return result;
}

+ (NSArray<NSDictionary<NSString *, id> *> *)arrayFromNDEFPayloads:(NSArray<NFCNDEFPayload *> *)payloads
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:payloads.count];
    
    for (NFCNDEFPayload *payload in payloads) {
        [result addObject:@{
            @"payload": [[TiBlob alloc] initWithData:payload.payload mimetype:@"text/plain"],
            @"type": [[NSString alloc] initWithData:payload.type encoding:NSUTF8StringEncoding],
            @"tnf": @(payload.typeNameFormat),
            @"id": [[NSString alloc] initWithData:payload.identifier encoding:NSUTF8StringEncoding]
        }];
    }
    
    return result;
}

@end

#endif
