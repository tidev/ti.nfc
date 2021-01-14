/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <CoreNFC/CoreNFC.h>
#import <TitaniumKit/TitaniumKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiNfcISODepTagTechnology : TiProxy {
  id<NFCISO7816Tag> _iso7816Tag;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andNFCISO7816Tag:(id<NFCISO7816Tag>)iso7816Tag;

- (id<NFCISO7816Tag>)iso7816Tag;

@end

NS_ASSUME_NONNULL_END
