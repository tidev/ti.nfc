/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcFTagTechnology.h"

@implementation TiNfcFTagTechnology

- (id)_initWithPageContext:(id<TiEvaluator>)context andNFCFeliCaTag:(id<NFCFeliCaTag>)felicaTag
{
  if (self = [super _initWithPageContext:context]) {
    _felicaTag = felicaTag;
  }
  return self;
}

- (id<NFCFeliCaTag>)felicaTag;
{
  return _felicaTag;
}

@end
