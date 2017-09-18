/**
 * Ti.NFC
 * Copyright (c) 2009-2017 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiNfcNdefRecordProxy.h"
#import "TiBlob.h"

@implementation TiNfcNdefRecordProxy

#pragma mark Internal

- (id)_initWithPageContext:(id<TiEvaluator>)context andRecord:(NFCNDEFPayload *)record
{
    if (self = [super _initWithPageContext:context]) {
        _record = record;
    }
}

#pragma mark Public API's

- (NSString *)id
{
    return [[NSString alloc] initWithData:[_record identifier] encoding:NSUTF8StringEncoding];
}

- (TiBlob *)payload
{
    return [[TiBlob alloc] initWithData:[_record payload] mimetype:@"text/plain"];
}

- (NSString *)type
{
    return [[NSString alloc] initWithData:[_record type] encoding:NSUTF8StringEncoding];
}

- (NSNumber *)tnf
{
    return NUMINT([_record typeNameFormat]);
}

@end

#endif
