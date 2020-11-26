/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcTagReaderSessionProxy.h"
#import "TiBlob.h"
#import "TiNfcUtilities.h"
#import "TiUtils.h"

@implementation TiNfcTagReaderSessionProxy

- (NFCTagReaderSession *)session
{
  if (_session == nil) {
    _session = [[NFCTagReaderSession alloc] initWithPollingOption:(NFCPollingISO14443 | NFCPollingISO15693 | NFCPollingISO15693) delegate:self queue:nil];
  }

  return _session;
}

#pragma mark Public API's

- (void)begin:(id)unused
{
  [[self session] beginSession];
}

- (void)invalidate:(id)unused
{
  [[self session] invalidateSession];
  _session = nil;
}

- (void)restartPolling:(id)unused
{
  [[self session] restartPolling];
}

- (NSNumber *)isEnabled:(id)unused
{
  if (![TiUtils isIOSVersionOrGreater:@"13.0"]) {
    return @(NO);
  }

  return @([NFCTagReaderSession readingAvailable]);
}

#pragma mark NFCReaderSessionDelegate

- (void)tagReaderSession:(NFCTagReaderSession *)session didInvalidateWithError:(NSError *)error
{
  [self fireEvent:@"didInvalidateWithError" withObject:@{ @"error" : error.localizedDescription, @"cancelled" : @(error.code == 200) }];
}

- (void)tagReaderSessionDidBecomeActive:(NFCTagReaderSession *)session
{
  [self fireEvent:@"tagReaderSessionDidBecomeActive"];
}

- (void)tagReaderSession:(NFCTagReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCTag>> *)tags
{
  if (tags.count == 0) {
    [self fireEvent:@"didInvalidateWithError" withObject:@{ @"error" : @"No tags found" }];
    return; // No tags found
  }

  if (tags[0].asNFCMiFareTag) {
    id<NFCMiFareTag> tag = tags[0].asNFCMiFareTag;
    if (tag == nil) {
      [self fireEvent:@"didInvalidateWithError" withObject:@{ @"error" : @"The found tag is not a MiFareTag tag" }];
      return;
    }

    NSString *stringIdentifier = [TiNfcUtilities _dataToHexString:[tag identifier]];

    [self fireEvent:@"didDetectTags"
         withObject:@{
           @"stringIdentifier" : NULL_IF_NIL(stringIdentifier),
         }];
  } else if (tags[0].asNFCISO15693Tag) {
    id<NFCISO15693Tag> tag = tags[0].asNFCISO15693Tag;
    if (tag == nil) {
      [self fireEvent:@"didInvalidateWithError" withObject:@{ @"error" : @"The found tag is not a ISO15693 tag" }];
      return;
    }

    NSString *stringIdentifier = [TiNfcUtilities _dataToHexString:[tag identifier]];

    [self fireEvent:@"didDetectTags"
         withObject:@{
           @"stringIdentifier" : NULL_IF_NIL(stringIdentifier),
         }];
  } else if (tags[0].asNFCFeliCaTag) {
    id<NFCFeliCaTag> tag = tags[0].asNFCFeliCaTag;
    if (tag == nil) {
      [self fireEvent:@"didInvalidateWithError" withObject:@{ @"error" : @"The found tag is not a FeliCa tag" }];
      return;
    }

    NSString *stringIdentifier = [TiNfcUtilities _dataToHexString:[tag currentSystemCode]];

    [self fireEvent:@"didDetectTags"
         withObject:@{
           @"stringIdentifier" : NULL_IF_NIL(stringIdentifier),
         }];
  } else if (tags[0].asNFCISO7816Tag) {
    id<NFCISO7816Tag> tag = tags[0].asNFCISO7816Tag;
    if (tag == nil) {
      [self fireEvent:@"didInvalidateWithError" withObject:@{ @"error" : @"The found tag is not a ISO7816 tag" }];
      return;
    }

    NSString *stringIdentifier = [TiNfcUtilities _dataToHexString:[tag identifier]];

    [self fireEvent:@"didDetectTags"
         withObject:@{
           @"stringIdentifier" : NULL_IF_NIL(stringIdentifier),
         }];
  }
}

@end
