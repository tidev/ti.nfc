/**
 * Ti.NFC
 * Copyright (c) 2009-2017 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiProxy.h"
#import <CoreNFC/CoreNFC.h>

@interface TiNfcNdefMessageProxy : TiProxy {
    NSArray<NFCNDEFPayload *> *_records;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andRecords:(NSArray<NFCNDEFPayload *> *)records;

@end

#endif
