/**
 * Ti.NFC
 * Copyright (c) 2009-2017 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiNfcNfcAdapterProxy.h"
#import "TiNfcNdefMessageProxy.h"
#import "TiNfcUtilities.h"
#import "TiUtils.h"

@implementation TiNfcNfcAdapterProxy

#pragma mark Internal

- (NFCNDEFReaderSession *)nfcSession
{
  if (_nfcSession == nil) {
    _nfcSession = [[NFCNDEFReaderSession alloc] initWithDelegate:self
                                                           queue:nil
                                        invalidateAfterFirstRead:[TiUtils boolValue:[self valueForKey:@"invalidateAfterFirstRead"] def:NO]];
  }

  return _nfcSession;
}

#pragma mark Public API's

- (void)begin:(id)unused
{
  [[self nfcSession] beginSession];
}

- (void)invalidate:(id)unused
{
  [[self nfcSession] invalidateSession];
  _nfcSession = nil;
}

- (void)setOnNdefDiscovered:(KrollCallback *)callback
{
  [self replaceValue:callback forKey:@"onNdefDiscovered" notification:NO];
  _ndefDiscoveredCallback = callback;
}

#pragma mark NFCNDEFReaderSessionDelegate

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[messages count]];

  for (NFCNDEFMessage *message in messages) {
    [result addObject:[[TiNfcNdefMessageProxy alloc] _initWithPageContext:[self pageContext]
                                                               andRecords:message.records]];
  }

  [_ndefDiscoveredCallback call:@[ @{
    @"messages" : [TiNfcUtilities arrayFromNDEFMessages:messages]
  } ]
                     thisObject:self];
}

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error
{
  [_ndefDiscoveredCallback call:@[ @{
    @"error" : [error localizedDescription],
    @"code": NUMINTEGER([error code])
  } ]
                     thisObject:self];
}

@end

#endif
