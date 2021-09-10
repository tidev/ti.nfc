/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcNDEFTagTechnology.h"
#import "TiNfcNdefMessageProxy.h"

@interface TiNfcNDEFTagTechnology ()

@property (nonatomic, weak) NFCNDEFReaderSession *session;
@property (nonatomic, weak) TiNfcNDEFTagProxy *tagProxy;

@end

@implementation TiNfcNDEFTagTechnology

- (id)_initWithPageContext:(id<TiEvaluator>)context
                andSession:(NFCNDEFReaderSession *)session
                    andTag:(TiNfcNDEFTagProxy *)tag
{
  if (self = [super _initWithPageContext:context]) {
    self.tagProxy = tag;
    self.session = session;
  }
  return self;
}

#pragma mark Public API's

- (void)connect:(id)unused
{
  [self.session connectToTag:[self.tagProxy tag]
           completionHandler:^(NSError *_Nullable error) {
             if (![self _hasListeners:@"didConnectTag"]) {
               return;
             }
             [error code];
             [self fireEvent:@"didConnectTag"
                  withObject:@{
                    @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                    @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                    @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                  }];
           }];
}

- (void)queryNDEFStatus:(id)unused
{
  [[self.tagProxy tag] queryNDEFStatusWithCompletionHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError *_Nullable error) {
    if (error == nil) {
      if (![self _hasListeners:@"didQueryNDEFStatus"]) {
        return;
      }
      [self fireEvent:@"didQueryNDEFStatus"
           withObject:@{
             @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
             @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
             @"errorDomain" : error != nil ? [error domain] : [NSNull null],
             @"status" : NUMINTEGER(status),
             @"capacity" : NUMINTEGER(capacity)
           }];
    }
  }];
}

- (void)readNDEF:(id)unused
{
  [[self.tagProxy tag] readNDEFWithCompletionHandler:^(NFCNDEFMessage *message, NSError *error) {
    if (error == nil) {
      if (![self _hasListeners:@"didReadNDEFMessage"]) {
        return;
      }
      [self fireEvent:@"didReadNDEFMessage"
           withObject:@{
             @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
             @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
             @"errorDomain" : error != nil ? [error domain] : [NSNull null],
             @"message" : [[TiNfcNdefMessageProxy alloc] _initWithPageContext:[self pageContext] andRecords:message.records]
           }];
    }
  }];
}

- (void)writeNDEF:(id)args
{
  TiNfcNdefMessageProxy *getProxyMessage = [[args firstObject] valueForKey:@"message"];
  NFCNDEFMessage *message = [[NFCNDEFMessage alloc] initWithNDEFRecords:getProxyMessage.nfcNdefPayloads];

  [[self.tagProxy tag] writeNDEF:message
               completionHandler:^(NSError *error) {
                 if (error == nil) {
                   if (![self _hasListeners:@"didWirteNDEFMessage"]) {
                     return;
                   }
                   [self fireEvent:@"didWirteNDEFMessage"
                        withObject:@{
                          @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                          @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                          @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                        }];
                 }
               }];
}

- (void)writeLock:(id)unused
{
  [[self.tagProxy tag] writeLockWithCompletionHandler:^(NSError *_Nullable error) {
    if (error == nil) {
      if (![self _hasListeners:@"didWriteLock"]) {
        return;
      }
      [self fireEvent:@"didWriteLock"
           withObject:@{
             @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
             @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
             @"errorDomain" : error != nil ? [error domain] : [NSNull null]
           }];
    }
  }];
}

@end
