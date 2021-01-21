/**
 * Ti.NFC
 * Copyright (c) 2009-2018 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiNfcNfcAdapterProxy.h"
#import "TiNfcFTagTechnology.h"
#import "TiNfcISODepTagTechnology.h"
#import "TiNfcMiFareUltralightTagTechnology.h"
#import "TiNfcModule.h"
#import "TiNfcNDEFTagTechnology.h"
#import "TiNfcNdefMessageProxy.h"
#import "TiNfcTagProxy.h"
#import "TiNfcVTagTechnology.h"
#import "TiUtils.h"

@implementation TiNfcNfcAdapterProxy

#pragma mark Internal

- (NFCNDEFReaderSession *)nfcSession
{
  // Guard older iOS versions already. The developer will use "isEnabled" later to actually guard the functionality
  // e.g. an iPad running iOS 11, but without NFC capabilities
  if (![TiUtils isIOSVersionOrGreater:@"13.0"]) {
    return nil;
  }

  if (_nfcSession == nil) {
    _nfcSession = [[NFCNDEFReaderSession alloc] initWithDelegate:self
                                                           queue:nil
                                        invalidateAfterFirstRead:[TiUtils boolValue:[self valueForKey:@"invalidateAfterFirstRead"] def:NO]];
  }

  return _nfcSession;
}

- (NFCTagReaderSession *)nfcTagReadersession:(NSString *)pollingOption
{
  if (_nfcTagReadersession == nil) {
    if ([pollingOption isEqualToString:@"NFCPollingISO14443"]) {
      _nfcTagReadersession = [[NFCTagReaderSession alloc] initWithPollingOption:NFCPollingISO14443 delegate:self queue:nil];
    } else if ([pollingOption isEqualToString:@"NFCPollingISO15693"]) {
      _nfcTagReadersession = [[NFCTagReaderSession alloc] initWithPollingOption:NFCPollingISO15693 delegate:self queue:nil];
    } else if ([pollingOption isEqualToString:@"NFCPollingISO18092"]) {
      _nfcTagReadersession = [[NFCTagReaderSession alloc] initWithPollingOption:NFCPollingISO18092 delegate:self queue:nil];
    } else {
      _nfcTagReadersession = [[NFCTagReaderSession alloc] initWithPollingOption:(NFCPollingISO14443 | NFCPollingISO15693 | NFCPollingISO15693) delegate:self queue:nil];
    }
  }

  return _nfcTagReadersession;
}

#pragma mark Public API's

- (NSNumber *)isEnabled:(id)type
{
  if (![TiUtils isIOSVersionOrGreater:@"13.0"]) {
    return @(NO);
  }
  NSString *sessionType = [[type objectAtIndex:0] valueForKey:@"type"];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    return @([NFCNDEFReaderSession readingAvailable]);
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    return @([NFCTagReaderSession readingAvailable]);
  }
}

- (void)begin:(id)type
{
  NSString *sessionType = [[type objectAtIndex:0] valueForKey:@"type"];
  NSString *pollingOption = [[type objectAtIndex:1] valueForKey:@"pollingOption"];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    [[self nfcSession] beginSession];
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    [[self nfcTagReadersession:pollingOption] beginSession];
  }
}

- (void)invalidate:(id)type
{
  NSString *sessionType = [[type objectAtIndex:0] valueForKey:@"type"];
  NSString *pollingOption = [[type objectAtIndex:1] valueForKey:@"pollingOption"];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    [[self nfcSession] invalidateSession];
    _nfcSession = nil;
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    [[self nfcTagReadersession:pollingOption] invalidateSession];
    _nfcTagReadersession = nil;
  }
}

- (TiNfcMiFareUltralightTagTechnology *)createTagTechMifareUltralight:(id)args
{
  if ([args valueForKey:@"tag"] == nil) {
    return;
  }
  TiNfcTagProxy *tag = [[args objectAtIndex:0] valueForKey:@"tag"];
  TiNfcMiFareUltralightTagTechnology *mifareTag = [[TiNfcMiFareUltralightTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcTagReadersession andTag:tag];
  return mifareTag;
}

- (TiNfcNDEFTagTechnology *)createTagTechNdef:(id)args
{
  if ([args valueForKey:@"tag"] == nil) {
    return;
  }
  TiNfcTagProxy *tag = [[args objectAtIndex:0] valueForKey:@"tag"];
  TiNfcNDEFTagTechnology *ndefTag = [[TiNfcNDEFTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcSession andTag:tag.tag];
  return ndefTag;
}

- (TiNfcVTagTechnology *)createTagTechNfcV:(id)args
{
  if ([args valueForKey:@"tag"] == nil) {
    return;
  }
  TiNfcTagProxy *tag = [[args objectAtIndex:0] valueForKey:@"tag"];
  TiNfcVTagTechnology *nfcvTag = [[TiNfcVTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcTagReadersession andTag:tag];
  return nfcvTag;
}

- (TiNfcISODepTagTechnology *)createTagTechISODep:(id)args
{
  if ([args valueForKey:@"tag"] == nil) {
    return;
  }
  TiNfcTagProxy *tag = [[args objectAtIndex:0] valueForKey:@"tag"];
  TiNfcISODepTagTechnology *isodepTag = [[TiNfcISODepTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcTagReadersession andTag:tag];
  return isodepTag;
}

- (TiNfcFTagTechnology *)createTagTechNfcF:(id)args
{
  if ([args valueForKey:@"tag"] == nil) {
    return;
  }
  TiNfcTagProxy *tag = [[args objectAtIndex:0] valueForKey:@"tag"];
  TiNfcFTagTechnology *nfcfTag = [[TiNfcFTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcTagReadersession andTag:tag];
  return nfcfTag;
}

- (void)setOnNdefDiscovered:(KrollCallback *)callback
{
  [self replaceValue:callback forKey:@"onNdefDiscovered" notification:NO];
  _ndefDiscoveredCallback = callback;
}

- (void)setOnNdefInvalidated:(KrollCallback *)callback
{
  [self replaceValue:callback forKey:@"onNdefInvalidated" notification:NO];
  _nNdefInvalidated = callback;
}

#pragma mark NFCNDEFReaderSessionDelegate

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages
{
  if (!_ndefDiscoveredCallback) {
    DebugLog(@"[ERROR] Detected NDEF-tags but no \"onNdefDiscovered\" callback specified!");
    return;
  }

  NSMutableSet<TiNfcNdefMessageProxy *> *result = [NSMutableSet setWithCapacity:messages.count];

  TiThreadPerformOnMainThread(
      ^{
        for (NFCNDEFMessage *message in messages) {
          [result addObject:[[TiNfcNdefMessageProxy alloc] _initWithPageContext:[self pageContext] andRecords:message.records]];
        }

        [_ndefDiscoveredCallback call:@[ @{
          @"messages" : result.allObjects
        } ]
                           thisObject:self];
      },
      NO);
}

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error
{
  // Make sure to clear the session so it can be recreated on the next attempt
  _nfcSession = nil;

  if (!_nNdefInvalidated) {
    return;
  }

  TiThreadPerformOnMainThread(
      ^{
        [_nNdefInvalidated call:@[ @{
          @"cancelled" : @(error.code == 200),
          @"message" : [error localizedDescription],
          @"code" : NUMINTEGER([error code]),
          @"type" : @"NFCNDEFReaderSession"
        } ]
                     thisObject:self];
      },
      NO);
}

#pragma mark NFCReaderSessionDelegate

- (void)tagReaderSession:(NFCTagReaderSession *)session didInvalidateWithError:(NSError *)error
{
  _nfcTagReadersession = nil;

  if (!_nNdefInvalidated) {
    return;
  }
  TiThreadPerformOnMainThread(
      ^{
        [_nNdefInvalidated call:@[ @{
          @"cancelled" : @(error.code == 200),
          @"message" : [error localizedDescription],
          @"code" : NUMINTEGER([error code]),
          @"type" : @"NFCTagReaderSession"
        } ]
                     thisObject:self];
      },
      NO);
}

- (void)tagReaderSessionDidBecomeActive:(NFCTagReaderSession *)session
{

  if (![self _hasListeners:@"tagReaderSessionDidBecomeActive"]) {
    return;
  }
  [self fireEvent:@"tagReaderSessionDidBecomeActive"
       withObject:@{
         @"type" : @"NFCTagReaderSession"
       }];
}

- (void)tagReaderSession:(NFCTagReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCTag>> *)tags
{
  if (![self _hasListeners:@"didDetectTags"]) {
    return;
  }
  TiNfcNativeTagTechnologyProxy *tagData = [[TiNfcNativeTagTechnologyProxy alloc] _initWithPageContext:[self pageContext] andSession:_nfcTagReadersession andTag:tags];
  [self fireEvent:@"didDetectTags"
       withObject:@{
         @"tags" : [NSArray arrayWithObject:tagData],
         @"session" : _nfcTagReadersession,
         @"type" : @"NFCTagReaderSession"
       }];
}

@end

#endif
