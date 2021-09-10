/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcNDEFTagProxy.h"
#import "TiNfcNativeTagTechnologyProxy.h"
#import <CoreNFC/CoreNFC.h>
#import <TitaniumKit/TitaniumKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiNfcNDEFTagTechnology : TiProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context
                andSession:(NFCNDEFReaderSession *)session
                    andTag:(TiNfcNDEFTagProxy *)tag;
- (void)connect:(id)unused;
- (void)queryNDEFStatus:(id)unused;
- (void)readNDEF:(id)unused;
- (void)writeNDEF:(id)args;
- (void)writeLock:(id)unused;

@end

NS_ASSUME_NONNULL_END
