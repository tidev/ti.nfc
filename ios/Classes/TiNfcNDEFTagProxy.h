/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <CoreNFC/CoreNFC.h>
#import <Foundation/Foundation.h>
#import <TitaniumKit/TitaniumKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiNfcNDEFTagProxy : TiProxy {
  id<NFCNDEFTag> _tag;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andTag:(id<NFCNDEFTag>)tag;
- (id<NFCNDEFTag>)tag;

@end

NS_ASSUME_NONNULL_END
