/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <CoreNFC/CoreNFC.h>
#import <TitaniumKit/TitaniumKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiNfcVTagTechnology : TiProxy {
  id<NFCISO15693Tag> _iso15693Tag;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andNFCISO15693Tag:(id<NFCISO15693Tag>)iso15693Tag;

- (id<NFCISO15693Tag>)iso15693Tag;

@end

NS_ASSUME_NONNULL_END
