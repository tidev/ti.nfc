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
#import "TiNfcNDEFTagProxy.h"
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
  if (![TiUtils isIOSVersionOrGreater:@"11.0"]) {
    return nil;
  }

  if (_nfcSession == nil) {
    _nfcSession = [[NFCNDEFReaderSession alloc] initWithDelegate:self
                                                           queue:nil
                                        invalidateAfterFirstRead:[TiUtils boolValue:[self valueForKey:@"invalidateAfterFirstRead"] def:NO]];
  }

  return _nfcSession;
}

- (NFCTagReaderSession *)nfcTagReadersession:(id)pollingOptions
{
  // As NFC Tag reader session is only available after iOS 13
  if (![TiUtils isIOSVersionOrGreater:@"13.0"]) {
    return nil;
  }
  NSInteger pollingValue = 0;
  for (int count = 0; count < [pollingOptions count]; count++) {
    NSInteger value = [[pollingOptions objectAtIndex:count] intValue];
    pollingValue = pollingValue | value;
  }
  if (_nfcTagReadersession == nil) {
    _nfcTagReadersession = [[NFCTagReaderSession alloc] initWithPollingOption:pollingValue delegate:self queue:nil];
  }
  return _nfcTagReadersession;
}

#pragma mark Public API's

- (NSNumber *)isEnabled:(id)type
{
  if (![TiUtils isIOSVersionOrGreater:@"11.0"]) {
    return @(NO);
  }
  NSString *sessionType = [[type firstObject] valueForKey:@"type"];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    return @([NFCNDEFReaderSession readingAvailable]);
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    return @([NFCTagReaderSession readingAvailable]);
  }
}

- (void)begin:(id)type
{
  NSString *sessionType = [[type firstObject] valueForKey:@"type"];
  NSArray *pollingOptions = [[type firstObject] valueForKey:@"pollingOptions"];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    [[self nfcSession] beginSession];
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    [[self nfcTagReadersession:pollingOptions] beginSession];
  }
}

- (void)invalidate:(id)type
{
  NSString *sessionType = [[type firstObject] valueForKey:@"type"];
  NSArray *pollingOptions = [[type firstObject] valueForKey:@"pollingOptions"];
  if ([sessionType isEqualToString:@"NFCNDEFReaderSession"]) {
    [[self nfcSession] invalidateSession];
    _nfcSession = nil;
  } else if ([sessionType isEqualToString:@"NFCTagReaderSession"]) {
    [[self nfcTagReadersession:pollingOptions] invalidateSession];
    _nfcTagReadersession = nil;
  }
}

- (TiNfcMiFareUltralightTagTechnology *)createTagTechMifareUltralight:(id)args
{
  if ([[args firstObject] valueForKey:@"tag"] == nil) {
    return nil;
  }
  TiNfcTagProxy *tag = [[args firstObject] valueForKey:@"tag"];
  TiNfcMiFareUltralightTagTechnology *mifareTag = [[TiNfcMiFareUltralightTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcTagReadersession andTag:tag];
  return mifareTag;
}

- (TiNfcNDEFTagTechnology *)createTagTechNdef:(id)args
{
  if ([[args firstObject] valueForKey:@"tag"] == nil) {
    return nil;
  }
  TiNfcNDEFTagProxy *tag = [[args firstObject] valueForKey:@"tag"];
  TiNfcNDEFTagTechnology *ndefTag = [[TiNfcNDEFTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcSession andTag:tag];
  return ndefTag;
}

- (TiNfcVTagTechnology *)createTagTechNfcV:(id)args
{
  if ([[args firstObject] valueForKey:@"tag"] == nil) {
    return nil;
  }
  TiNfcTagProxy *tag = [[args firstObject] valueForKey:@"tag"];
  TiNfcVTagTechnology *nfcvTag = [[TiNfcVTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcTagReadersession andTag:tag];
  return nfcvTag;
}

- (TiNfcISODepTagTechnology *)createTagTechISODep:(id)args
{
  if ([[args firstObject] valueForKey:@"tag"] == nil) {
    return nil;
  }
  TiNfcTagProxy *tag = [[args firstObject] valueForKey:@"tag"];
  TiNfcISODepTagTechnology *isodepTag = [[TiNfcISODepTagTechnology alloc] _initWithPageContext:[self pageContext] andSession:_nfcTagReadersession andTag:tag];
  return isodepTag;
}

- (TiNfcFTagTechnology *)createTagTechNfcF:(id)args
{
  if ([[args firstObject] valueForKey:@"tag"] == nil) {
    return nil;
  }
  TiNfcTagProxy *tag = [[args firstObject] valueForKey:@"tag"];
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

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCNDEFTag>> *)tags
{
  if (![self _hasListeners:@"didDetectTags"]) {
    return;
  }
  NSMutableArray *tagData = [[NSMutableArray alloc] init];
  for (id<NFCNDEFTag> tag in tags) {
    [tagData addObject:[[TiNfcNDEFTagProxy alloc] _initWithPageContext:[self pageContext] andTag:tag]];
  }
  [self fireEvent:@"didDetectTags"
       withObject:@{
         @"tags" : tagData,
         @"type" : @"NFCNDEFReaderSession"
       }];
}

- (void)readerSessionDidBecomeActive:(NFCNDEFReaderSession *)session
{
  if (![self _hasListeners:@"tagReaderSessionDidBecomeActive"]) {
    return;
  }
  [self fireEvent:@"tagReaderSessionDidBecomeActive"
       withObject:@{
         @"type" : @"NFCNDEFReaderSession"
       }];
}

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

        [self->_ndefDiscoveredCallback call:@[ @{
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

  _nfcTagReadersession = nil;
  if (![self _hasListeners:@"didInvalidateWithError"]) {
    return;
  }
  [self fireEvent:@"didInvalidateWithError"
       withObject:@{
         @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
         @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
         @"errorDomain" : error != nil ? [error domain] : [NSNull null],
         @"type" : @"NFCTagReaderSession"
       }];

  if (!_nNdefInvalidated) {
    return;
  }

  TiThreadPerformOnMainThread(
      ^{
        [self->_nNdefInvalidated call:@[ @{
          @"cancelled" : @(error.code == 200),
          @"message" : [error localizedDescription],
          @"code" : NUMINTEGER([error code]),
          @"type" : @"NFCNDEFReaderSession"
        } ]
                     thisObject:self];
      },
      NO);
}

#pragma mark NFCTagReaderSessionDelegate

- (void)tagReaderSession:(NFCTagReaderSession *)session didInvalidateWithError:(NSError *)error
{
  _nfcTagReadersession = nil;
  if (![self _hasListeners:@"didInvalidateWithError"]) {
    return;
  }
  [self fireEvent:@"didInvalidateWithError"
       withObject:@{
         @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
         @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
         @"errorDomain" : error != nil ? [error domain] : [NSNull null],
         @"type" : @"NFCTagReaderSession"
       }];
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
  NSMutableArray *tagData = [[NSMutableArray alloc] init];
  for (id<NFCTag> tag in tags) {
    [tagData addObject:[[TiNfcTagProxy alloc] _initWithPageContext:[self pageContext] andTag:tag]];
  }
  [self fireEvent:@"didDetectTags"
       withObject:@{
         @"tags" : tagData,
         @"type" : @"NFCTagReaderSession"
       }];
}

@end

#endif
