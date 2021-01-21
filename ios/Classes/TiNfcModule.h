/**
 * Ti.NFC
 * Copyright (c) 2009-2018 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"

@interface TiNfcModule : TiModule {
}
@property (nonatomic, readonly) NSNumber *NDEF_READER_SESSION;
@property (nonatomic, readonly) NSNumber *NFC_TAG_READER_SESSION;
@property (nonatomic, readonly) NSNumber *NFC_TAG_ISO14443;
@property (nonatomic, readonly) NSNumber *NFC_TAG_ISO15693;
@property (nonatomic, readonly) NSNumber *NFC_TAG_ISO18092;

@end
