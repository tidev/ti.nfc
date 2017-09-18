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

- (id)_initWithPageContext:(id<TiEvaluator>)context
{
  if (self = [super _initWithPageContext:context]) {
    _ndefDiscoveredCallback = [self valueForKey:@"onNdefDiscovered"];
  }

  return self;
}

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
    @"error" : [error localizedDescription]
  } ]
                     thisObject:self];
}

@end

#endif
