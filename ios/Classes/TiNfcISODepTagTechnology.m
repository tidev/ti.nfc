/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcISODepTagTechnology.h"

@implementation TiNfcISODepTagTechnology

- (id)_initWithPageContext:(id<TiEvaluator>)context andNFCISO7816Tag:(id<NFCISO7816Tag>)iso7816Tag
{
  if (self = [super _initWithPageContext:context]) {
    _iso7816Tag = iso7816Tag;
  }
  return self;
}

- (id<NFCISO7816Tag>)iso7816Tag;
{
  return _iso7816Tag;
}

@end
