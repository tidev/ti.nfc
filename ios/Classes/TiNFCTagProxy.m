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

- (id)_initWithPageContext:(id<TiEvaluator>)context andSession:(NFCNDEFReaderSession *)session andTag:(id<NFCTag>)tag
{
  if (self = [super _initWithPageContext:context]) {
    _tag = tag;
    session = session;
  }
  return self;
}

#pragma mark Public API's

- (NSNumber *)available
{
  return NUMINT([_tag isAvailable]);
}

- (id<NFCTag>)tag
{
  return _tag;
}

@end
