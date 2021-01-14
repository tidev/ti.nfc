/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcVTagTechnology.h"

@implementation TiNfcVTagTechnology

- (id)_initWithPageContext:(id<TiEvaluator>)context andNFCISO15693Tag:(id<NFCISO15693Tag>)iso15693Tag
{
  if (self = [super _initWithPageContext:context]) {
    _iso15693Tag = iso15693Tag;
  }
  return self;
}

- (id<NFCISO15693Tag>)iso15693Tag
{
  return _iso15693Tag;
}

@end
