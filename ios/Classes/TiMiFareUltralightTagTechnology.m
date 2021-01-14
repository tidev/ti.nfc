/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiMiFareUltralightTagTechnology.h"

@implementation TiMiFareUltralightTagTechnology

- (id)_initWithPageContext:(id<TiEvaluator>)context andMiFareTag:(id<NFCMiFareTag>)mifareTag
{
  if (self = [super _initWithPageContext:context]) {
    _mifareTag = mifareTag;
  }
  return self;
}

- (id<NFCMiFareTag>)mifareTag;
{
  return _mifareTag;
}

@end
