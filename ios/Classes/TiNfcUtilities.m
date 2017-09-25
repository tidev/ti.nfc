/**
 * Ti.NFC
 * Copyright (c) 2009-2017 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiNfcUtilities.h"
#import "TiBlob.h"

@implementation TiNfcUtilities

+ (NSArray<NSDictionary<NSString *, id> *> *)arrayFromNDEFMessages:(NSArray<NFCNDEFMessage *> *)messages;
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:messages.count];

  for (NFCNDEFMessage *message in messages) {
    [result addObject:@{
      @"records" : [TiNfcUtilities arrayFromNDEFPayloads:message.records]
    }];
  }

  return result;
}

+ (NSArray<NSDictionary<NSString *, id> *> *)arrayFromNDEFPayloads:(NSArray<NFCNDEFPayload *> *)payloads
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:payloads.count];

  for (NFCNDEFPayload *payload in payloads) {
    [result addObject:@{
      @"payload" : NULL_IF_NIL([[TiBlob alloc] initWithData:payload.payload mimetype:@"text/plain"]),
      @"type" : NULL_IF_NIL([[NSString alloc] initWithData:payload.type encoding:NSUTF8StringEncoding]),
      @"tnf" : @(payload.typeNameFormat),
      @"id" : NULL_IF_NIL([[NSString alloc] initWithData:payload.identifier encoding:NSUTF8StringEncoding])
    }];
  }

  return result;
}

@end

#endif
