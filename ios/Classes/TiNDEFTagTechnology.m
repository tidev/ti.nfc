/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNDEFTagTechnology.h"

@implementation TiNDEFTagTechnology

- (id)_initWithPageContext:(id<TiEvaluator>)context andNDEFTag:(id<NFCNDEFTag>)ndefTag
{
  if (self = [super _initWithPageContext:context]) {
    _ndefTag = ndefTag;
  }
  return self;
}

- (id<NFCNDEFTag>)ndefTag
{
  return _ndefTag;
}

@end
