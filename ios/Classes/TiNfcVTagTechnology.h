/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcNativeTagTechnologyProxy.h"
#import <CoreNFC/CoreNFC.h>
#import <TitaniumKit/TitaniumKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiNfcVTagTechnology : TiNfcNativeTagTechnologyProxy

- (TiBuffer *)identifier;
- (NSNumber *)icManufacturerCode;
- (TiBuffer *)icSerialNumber;
- (void)readSingleBlockWithRequestFlags:(id)args;
- (void)writeSingleBlockWithRequestFlags:(id)args;
- (void)lockBlockWithRequestFlags:(id)args;
- (void)readMultipleBlocksWithRequestFlags:(id)args;
- (void)writeMultipleBlocksWithRequestFlags:(id)args;
- (void)getMultipleBlockSecurityStatusWithRequestFlag:(id)args;
- (void)writeAFIWithRequestFlag:(id)args;
- (void)lockAFIWithRequestFlag:(id)args;
- (void)writeDSFIDWithRequestFlag:(id)args;
- (void)resetToReadyWithRequestFlags:(id)args;
- (void)selectWithRequestFlags:(id)args;
- (void)stayQuiet:(id)args;
- (void)customCommandWithRequestFlag:(id)args;
- (void)extendedReadSingleBlockWithRequestFlags:(id)args;
- (void)extendedWriteSingleBlockWithRequestFlags:(id)args;
- (void)extendedLockBlockWithRequestFlags:(id)args;
- (void)extendedReadMultipleBlocksWithRequestFlags:(id)args;
- (void)lockDSFIDWithRequestFlag:(id)args;
- (void)authenticateWithRequestFlags:(id)args;
- (void)challengeWithRequestFlags:(id)args;
- (void)extendedFastReadMultipleBlocksWithRequestFlag:(id)args;
- (void)extendedGetMultipleBlockSecurityStatusWithRequestFlag:(id)args;
- (void)extendedWriteMultipleBlocksWithRequestFlags:(id)args;
- (void)fastReadMultipleBlocksWithRequestFlag:(id)args;
- (void)getSystemInfoAndUIDWithRequestFlag:(id)args;
- (void)keyUpdateWithRequestFlags:(id)args;
- (void)readBufferWithRequestFlags:(id)args;
- (void)sendRequestWithFlag:(id)args;

@end

NS_ASSUME_NONNULL_END
