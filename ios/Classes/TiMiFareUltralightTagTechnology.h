/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <CoreNFC/CoreNFC.h>
#import <TitaniumKit/TitaniumKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiMiFareUltralightTagTechnology : TiProxy {
  id<NFCMiFareTag> _mifareTag;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andMiFareTag:(id<NFCMiFareTag>)mifareTag;

- (id<NFCMiFareTag>)mifareTag;

@end

NS_ASSUME_NONNULL_END
