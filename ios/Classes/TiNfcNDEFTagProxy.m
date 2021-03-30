/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcNDEFTagProxy.h"

@implementation TiNfcNDEFTagProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context
                    andTag:(id<NFCNDEFTag>)tag
{
  if (self = [super _initWithPageContext:context]) {
    _tag = tag;
  }
  return self;
}

- (id<NFCNDEFTag>)tag
{
  return _tag;
}

- (NSNumber *)available
{
  return NUMINT([_tag isAvailable]);
}

@end
