/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcTagProxy.h"
#import "TiProxy.h"

@implementation TiNfcTagProxy

#pragma mark Internal

- (id)_initWithPageContext:(id<TiEvaluator>)context andTag:(id<NFCTag>)tag
{
  if (self = [super _initWithPageContext:context]) {
    _tag = tag;
  }
  return self;
}

- (id<NFCMiFareTag>)asNFCMiFareTag
{
  return [_tag asNFCMiFareTag];
}

- (id<NFCISO15693Tag>)asNFCISO15693Tag
{
  return [_tag asNFCISO15693Tag];
}

- (id<NFCFeliCaTag>)asNFCFeliCaTag
{
  return [_tag asNFCFeliCaTag];
}

- (id<NFCISO7816Tag>)asNFCISO7816Tag
{
  return [_tag asNFCISO7816Tag];
}

#pragma mark Public API's

- (NSNumber *)available
{
  return NUMINT([_tag isAvailable]);
}

- (NSNumber *)nfcTagType
{
  return NUMINTEGER([_tag type]);
}

- (id<NFCTag>)tag
{
  return _tag;
}

@end
