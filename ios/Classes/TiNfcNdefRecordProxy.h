/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_DEVICE && defined(IS_XCODE_9)
#import "TiProxy.h"
#import <CoreNFC/CoreNFC.h>

@interface TiNfcNdefRecordProxy : TiProxy {
    NFCNDEFPayload *_record;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andRecord:(NFCNDEFPayload *)record;

@end
#endif
