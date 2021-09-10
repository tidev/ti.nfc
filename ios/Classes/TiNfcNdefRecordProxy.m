/**
 * Ti.NFC
 * Copyright (c) 2009-2018 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiNfcNdefRecordProxy.h"
#import "TiBase.h"
#import "TiBlob.h"
#import "TiNfcUtilities.h"

@implementation TiNfcNdefRecordProxy

#pragma mark Internal

- (id)_initWithPageContext:(id<TiEvaluator>)context andRecord:(NFCNDEFPayload *)record
{
  if (self = [super _initWithPageContext:context]) {
    _record = record;
  }

  return self;
}

#pragma mark Public API's

- (NSString *)id
{
  return [[NSString alloc] initWithData:[_record identifier] encoding:NSUTF8StringEncoding];
}

- (TiBlob *)payload
{
  return [[TiBlob alloc] initWithData:_record.payload mimetype:self.type];
}

- (NSString *)text
{
  NSString *value;

  switch (_record.typeNameFormat) {
  case NFCTypeNameFormatNFCWellKnown: {
    NSURL *url = [_record wellKnownTypeURIPayload];
    if (url) {
      value = url.absoluteString;
    } else {
      NSLocale *locale;
      value = [_record wellKnownTypeTextPayloadWithLocale:&locale];
    }
    break;
  }

  case NFCTypeNameFormatAbsoluteURI: {
    value = [[NSString alloc] initWithData:_record.payload encoding:NSUTF8StringEncoding];
    break;
  }

  default:
    value = nil;
  }

  return value;
}

- (NSString *)type
{
  return [[NSString alloc] initWithData:_record.type encoding:NSUTF8StringEncoding];
}

- (NSNumber *)tnf
{
  return NUMINT([_record typeNameFormat]);
}

@end

#endif
