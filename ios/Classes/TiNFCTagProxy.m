/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNFCTagProxy.h"
#import "TiProxy.h"

@implementation TiNFCTagProxy

#pragma mark Internal

- (id)_initWithPageContext:(id<TiEvaluator>)context andTag:(id<NFCTag>)tag
{
  if (self = [super _initWithPageContext:context]) {
    _tag = tag;
  }
  return self;
}

#pragma mark Public API's

- (NSNumber *)available
{
  return NUMINT([_tag isAvailable]);
}

@end
