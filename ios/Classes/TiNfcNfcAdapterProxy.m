/**
 * Ti.NFC
 * Copyright (c) 2009-2018 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiNfcNfcAdapterProxy.h"
#import "TiMiFareUltralightTagTechnology.h"
#import "TiNDEFTagTechnology.h"
#import "TiNFCTagProxy.h"
#import "TiNfcFTagTechnology.h"
#import "TiNfcISODepTagTechnology.h"
#import "TiNfcModule.h"
#import "TiNfcNdefMessageProxy.h"
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

- (NFCTagReaderSession *)nfcTagReadersession
{
  if (_nfcTagReadersession == nil) {
    _nfcTagReadersession = [[NFCTagReaderSession alloc] initWithPollingOption:NFCPollingISO14443 delegate:self queue:nil];
  }

  return _nfcTagReadersession;
}

#pragma mark Public API's

- (NSNumber *)isEnabled:(id)unused
{
  if (![TiUtils isIOSVersionOrGreater:@"13.0"]) {
    return @(NO);
  }
  ENSURE_SINGLE_ARG(unused, NSArray);
  NSString *sessionType = [unused objectAtIndex:0];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    return @([NFCNDEFReaderSession readingAvailable]);
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    return @([NFCTagReaderSession readingAvailable]);
  }
}

- (void)begin:(id)unused
{
  ENSURE_SINGLE_ARG(unused, NSArray);
  NSString *sessionType = [unused objectAtIndex:0];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    [[self nfcSession] beginSession];
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    [[self nfcTagReadersession] beginSession];
  }
}

- (void)invalidate:(id)unused
{
  ENSURE_SINGLE_ARG(unused, NSArray);
  NSString *sessionType = [unused objectAtIndex:0];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    [[self nfcSession] invalidateSession];
    _nfcSession = nil;
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    [[self nfcTagReadersession] invalidateSession];
    _nfcTagReadersession = nil;
  }
}

- (TiMiFareUltralightTagTechnology *)createTagTechMifareUltralight:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);
  TiNFCTagProxy *tag = [args objectAtIndex:0];
  TiMiFareUltralightTagTechnology *mifareTag = [[TiMiFareUltralightTagTechnology alloc] init];
    mifareTag.session
  return mifareTag;
}

- (TiNDEFTagTechnology *)createTagTechNdef:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);
  TiNFCTagProxy *tag = [args objectAtIndex:0];
  TiNDEFTagTechnology *ndefTag = [[TiNDEFTagTechnology alloc] init];
  return ndefTag;
}

- (TiNfcVTagTechnology *)createTagTechNfcV:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);
  TiNFCTagProxy *tag = [args objectAtIndex:0];
  TiNfcVTagTechnology *nfcvTag = [[TiNfcVTagTechnology alloc] init];
  return nfcvTag;
}

- (TiNfcISODepTagTechnology *)createTagTechISODep:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);
  TiNFCTagProxy *tag = [args objectAtIndex:0];
  TiNfcISODepTagTechnology *isodepTag = [[TiNfcISODepTagTechnology alloc] init];
  return isodepTag;
}

- (TiNfcFTagTechnology *)createTagTechNfcF:(id)args
{
  ENSURE_SINGLE_ARG(args, NSArray);
  TiNFCTagProxy *tag = [args objectAtIndex:0];
  TiNfcFTagTechnology *nfcfTag = [[TiNfcFTagTechnology alloc] init];
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
          @"type" : NDEF_READER_SESSION
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
          @"type" : NFC_TAG_READER_SESSION
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
         @"type" : NFC_TAG_READER_SESSION
       }];
  [self fireEvent:@"tagReaderSessionDidBecomeActive"];
}

- (void)tagReaderSession:(NFCTagReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCTag>> *)tags
{
  if (![self _hasListeners:@"didDetectTags"]) {
    return;
  }
  id<NFCMiFareTag> tag = tags[0].asNFCMiFareTag;
  [self fireEvent:@"didDetectTags"
       withObject:@{
         @"tag" : [[TiNFCTagProxy alloc] _initWithPageContext:[self pageContext] andTag:tag],
         @"type" : NFC_TAG_READER_SESSION
       }];
}

@end

#endif
