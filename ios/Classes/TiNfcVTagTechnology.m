/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcVTagTechnology.h"

@implementation TiNfcVTagTechnology

- (NSNumber *)icManufacturerCode
{
  return NUMINTEGER([[self.tagProxy asNFCISO15693Tag] icManufacturerCode]);
}

- (TiBuffer *)identifier
{
  TiBuffer *identifier = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
  NSMutableData *data = [NSMutableData dataWithData:[[self.tagProxy asNFCISO15693Tag] identifier]];
  [identifier setData:data];
  return identifier;
}

- (TiBuffer *)icSerialNumber
{
  TiBuffer *historicalBytes = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
  NSMutableData *data = [NSMutableData dataWithData:[[self.tagProxy asNFCISO15693Tag] icSerialNumber]];
  [historicalBytes setData:data];
  return historicalBytes;
}

- (void)readSingleBlockWithRequestFlags:(id)args
{

  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *blockNumberValue = [[args firstObject] valueForKey:@"blockNumber"];
  uint8_t blockNumber = [blockNumberValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] readSingleBlockWithRequestFlags:requestFlags
                                                        blockNumber:blockNumber
                                                  completionHandler:^(NSData *_Nonnull data, NSError *_Nullable error) {
                                                    if (![self _hasListeners:@"didReadSingleBlockWithRequestFlags"]) {
                                                      return;
                                                    }
                                                    TiBuffer *responseData = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
                                                    NSMutableData *responsevalue = [NSMutableData dataWithData:data];
                                                    [responseData setData:responsevalue];
                                                    [self fireEvent:@"didReadSingleBlockWithRequestFlags"
                                                         withObject:@{
                                                           @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                           @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                           @"errorDomain" : error != nil ? [error domain] : [NSNull null],
                                                           @"responseDataLength" : responseData.length

                                                         }];
                                                  }];
}

- (void)writeSingleBlockWithRequestFlags:(id)args
{

  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *blockNumberValue = [[args firstObject] valueForKey:@"blockNumber"];
  uint8_t blockNumber = [blockNumberValue unsignedCharValue];

  TiBuffer *dataBlock = [[args firstObject] valueForKey:@"blockNumber"];

  [[self.tagProxy asNFCISO15693Tag] writeSingleBlockWithRequestFlags:requestFlags
                                                         blockNumber:blockNumber
                                                           dataBlock:dataBlock.data
                                                   completionHandler:^(NSError *_Nullable error) {
                                                     if (![self _hasListeners:@"didWriteSingleBlockWithRequestFlags"]) {
                                                       return;
                                                     }
                                                     [self fireEvent:@"didWriteSingleBlockWithRequestFlags"
                                                          withObject:@{
                                                            @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                            @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                            @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                          }];
                                                   }];
}

- (void)lockBlockWithRequestFlags:(id)args
{

  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *blockNumberValue = [[args firstObject] valueForKey:@"blockNumber"];
  uint8_t blockNumber = [blockNumberValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] lockBlockWithRequestFlags:requestFlags
                                                  blockNumber:blockNumber
                                            completionHandler:^(NSError *_Nullable error) {
                                              if (![self _hasListeners:@"didLockBlockWithRequestFlags"]) {
                                                return;
                                              }
                                              [self fireEvent:@"didLockBlockWithRequestFlags"
                                                   withObject:@{
                                                     @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                     @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                     @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                   }];
                                            }];
}

- (void)readMultipleBlocksWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *blockNumberValue = [[args firstObject] valueForKey:@"blockNumber"];
  uint8_t blockNumber = [blockNumberValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] readSingleBlockWithRequestFlags:requestFlags
                                                        blockNumber:blockNumber
                                                  completionHandler:^(NSData *_Nonnull data, NSError *_Nullable error) {
                                                    if (![self _hasListeners:@"didReadMultipleBlocksWithRequestFlags"]) {
                                                      return;
                                                    }
                                                    TiBuffer *responseData = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
                                                    NSMutableData *responsevalue = [NSMutableData dataWithData:data];
                                                    [responseData setData:responsevalue];
                                                    [self fireEvent:@"didReadMultipleBlocksWithRequestFlags"
                                                         withObject:@{
                                                           @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                           @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                           @"errorDomain" : error != nil ? [error domain] : [NSNull null],
                                                           @"responseDataLength" : responseData.length

                                                         }];
                                                  }];
}

- (void)writeMultipleBlocksWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  TiBuffer *responseDataValue = [[args firstObject] valueForKey:@"blockNumber"];
  NSArray *dataBlock = [[NSArray alloc] initWithObjects:responseDataValue, nil];

  [[self.tagProxy asNFCISO15693Tag] writeMultipleBlocksWithRequestFlags:requestFlags
                                                             blockRange:NSMakeRange(0, 8)
                                                             dataBlocks:dataBlock
                                                      completionHandler:^(NSError *_Nullable error) {
                                                        if (![self _hasListeners:@"didWriteMultipleBlocksWithRequestFlags"]) {
                                                          return;
                                                        }
                                                        [self fireEvent:@"didWriteMultipleBlocksWithRequestFlags"
                                                             withObject:@{
                                                               @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                               @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                               @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                             }];
                                                      }];
}

- (void)getMultipleBlockSecurityStatusWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] getMultipleBlockSecurityStatusWithRequestFlag:requestFlags
                                                                       blockRange:NSMakeRange(0, 8)
                                                                completionHandler:^(NSArray<NSNumber *> *_Nonnull securityStatus, NSError *_Nullable error) {
                                                                  if (![self _hasListeners:@"didGetMultipleBlockSecurityStatusWithRequestFlag"]) {
                                                                    return;
                                                                  }
                                                                  [self fireEvent:@"didGetMultipleBlockSecurityStatusWithRequestFlag"
                                                                       withObject:@{
                                                                         @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                                         @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                                         @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                                       }];
                                                                }];
}

- (void)writeAFIWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *afiValue = [[args firstObject] valueForKey:@"afi"];
  uint8_t afi = [afiValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] writeAFIWithRequestFlag:requestFlags
                                                        afi:afi
                                          completionHandler:^(NSError *_Nullable error) {
                                            if (![self _hasListeners:@"didWriteAFIWithRequestFlag"]) {
                                              return;
                                            }
                                            [self fireEvent:@"didWriteAFIWithRequestFlag"
                                                 withObject:@{
                                                   @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                   @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                   @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                 }];
                                          }];
}

- (void)lockAFIWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *afiValue = [[args firstObject] valueForKey:@"afi"];
  uint8_t afi = [afiValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] writeAFIWithRequestFlag:requestFlags
                                                        afi:afi
                                          completionHandler:^(NSError *_Nullable error) {
                                            if (![self _hasListeners:@"didLockAFIWithRequestFlag"]) {
                                              return;
                                            }
                                            [self fireEvent:@"didLockAFIWithRequestFlag"
                                                 withObject:@{
                                                   @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                   @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                   @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                 }];
                                          }];
}

- (void)writeDSFIDWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *dsfidValue = [[args firstObject] valueForKey:@"dsfid"];
  uint8_t dsfid = [dsfidValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] writeDSFIDWithRequestFlag:requestFlags
                                                        dsfid:dsfid
                                            completionHandler:^(NSError *_Nullable error) {
                                              if (![self _hasListeners:@"didWriteDSFIDWithRequestFlag"]) {
                                                return;
                                              }
                                              [self fireEvent:@"didWriteDSFIDWithRequestFlag"
                                                   withObject:@{
                                                     @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                     @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                     @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                   }];
                                            }];
}

- (void)resetToReadyWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] resetToReadyWithRequestFlags:requestFlags
                                               completionHandler:^(NSError *_Nullable error) {
                                                 if (![self _hasListeners:@"didResetToReadyWithRequestFlags"]) {
                                                   return;
                                                 }
                                                 [self fireEvent:@"didResetToReadyWithRequestFlags"
                                                      withObject:@{
                                                        @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                        @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                        @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                      }];
                                               }];
}

- (void)selectWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] selectWithRequestFlags:requestFlags
                                         completionHandler:^(NSError *_Nullable error) {
                                           if (![self _hasListeners:@"didSelectWithRequestFlags"]) {
                                             return;
                                           }
                                           [self fireEvent:@"didSelectWithRequestFlags"
                                                withObject:@{
                                                  @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                  @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                  @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                }];
                                         }];
}

- (void)stayQuiet:(id)args
{
  [[self.tagProxy asNFCISO15693Tag] stayQuietWithCompletionHandler:^(NSError *_Nullable error) {
    if (![self _hasListeners:@"didStayQuiet"]) {
      return;
    }
    [self _hasListeners:@"didStayQuiet"];
  }];
}
- (void)customCommandWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *customCommandCode = [[args firstObject] valueForKey:@"customCommandCode"];

  TiBuffer *customRequestParameters = [[args firstObject] valueForKey:@"customRequestParameters"];

  [[self.tagProxy asNFCISO15693Tag] customCommandWithRequestFlag:requestFlags
                                               customCommandCode:[customCommandCode integerValue]
                                         customRequestParameters:customRequestParameters.data
                                               completionHandler:^(NSData *_Nonnull customResponseParameters, NSError *_Nullable error) {
                                                 if (![self _hasListeners:@"didCustomCommandWithRequestFlag"]) {
                                                   return;
                                                 }
                                                 TiBuffer *responseData = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
                                                 NSMutableData *responsevalue = [NSMutableData dataWithData:customResponseParameters];
                                                 [responseData setData:responsevalue];
                                                 [self fireEvent:@"didCustomCommandWithRequestFlag"
                                                      withObject:@{
                                                        @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                        @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                        @"errorDomain" : error != nil ? [error domain] : [NSNull null],
                                                        @"responseDataLength" : responseData.length
                                                      }];
                                               }];
}

- (void)extendedReadSingleBlockWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *blockNumber = [[args firstObject] valueForKey:@"blockNumber"];

  [[self.tagProxy asNFCISO15693Tag] extendedReadSingleBlockWithRequestFlags:requestFlags
                                                                blockNumber:[blockNumber integerValue]
                                                          completionHandler:^(NSData *_Nonnull data, NSError *_Nullable error) {
                                                            if (![self _hasListeners:@"didExtendedReadSingleBlockWithRequestFlags"]) {
                                                              return;
                                                            }
                                                            TiBuffer *responseData = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
                                                            NSMutableData *responsevalue = [NSMutableData dataWithData:data];
                                                            [responseData setData:responsevalue];
                                                            [self fireEvent:@"didExtendedReadSingleBlockWithRequestFlags"
                                                                 withObject:@{
                                                                   @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                                   @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                                   @"errorDomain" : error != nil ? [error domain] : [NSNull null],
                                                                   @"responseDataLength" : responseData.length
                                                                 }];
                                                          }];
}

- (void)extendedWriteSingleBlockWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *blockNumber = [[args firstObject] valueForKey:@"blockNumber"];

  TiBuffer *dataBlock = [[args firstObject] valueForKey:@"dataBlock"];

  [[self.tagProxy asNFCISO15693Tag] extendedWriteSingleBlockWithRequestFlags:requestFlags
                                                                 blockNumber:[blockNumber integerValue]
                                                                   dataBlock:dataBlock.data
                                                           completionHandler:^(NSError *_Nullable error) {
                                                             if (![self _hasListeners:@"didExtendedReadSingleBlockWithRequestFlags"]) {
                                                               return;
                                                             }
                                                             [self fireEvent:@"didExtendedReadSingleBlockWithRequestFlags"
                                                                  withObject:@{
                                                                    @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                                    @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                                    @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                                  }];
                                                           }];
}

- (void)extendedLockBlockWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *blockNumber = [[args firstObject] valueForKey:@"blockNumber"];

  [[self.tagProxy asNFCISO15693Tag] extendedLockBlockWithRequestFlags:requestFlags
                                                          blockNumber:[blockNumber integerValue]
                                                    completionHandler:^(NSError *_Nullable error) {
                                                      if (![self _hasListeners:@"didExtendedReadSingleBlockWithRequestFlags"]) {
                                                        return;
                                                      }
                                                      [self fireEvent:@"didExtendedReadSingleBlockWithRequestFlags"
                                                           withObject:@{
                                                             @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                             @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                             @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                           }];
                                                    }];
}

- (void)extendedReadMultipleBlocksWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *blockNumber = [[args firstObject] valueForKey:@"blockNumber"];

  [[self.tagProxy asNFCISO15693Tag] extendedLockBlockWithRequestFlags:requestFlags
                                                          blockNumber:[blockNumber integerValue]
                                                    completionHandler:^(NSError *_Nullable error) {
                                                      if (![self _hasListeners:@"didExtendedReadMultipleBlocksWithRequestFlags"]) {
                                                        return;
                                                      }
                                                      [self fireEvent:@"didExtendedReadMultipleBlocksWithRequestFlags"
                                                           withObject:@{
                                                             @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                             @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                             @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                           }];
                                                    }];
}

- (void)lockDSFIDWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] lockDSFIDWithRequestFlag:requestFlags
                                           completionHandler:^(NSError *_Nullable error) {
                                             if (![self _hasListeners:@"didLockDSFIDWithRequestFlag"]) {
                                               return;
                                             }
                                             [self fireEvent:@"didLockDSFIDWithRequestFlag"
                                                  withObject:@{
                                                    @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                    @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                    @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                  }];
                                           }];
}

- (void)authenticateWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *cryptoSuiteIdentifier = [[args firstObject] valueForKey:@"cryptoSuiteIdentifier"];

  TiBuffer *message = [[args firstObject] valueForKey:@"message"];

  [[self.tagProxy asNFCISO15693Tag] authenticateWithRequestFlags:requestFlags
                                           cryptoSuiteIdentifier:[cryptoSuiteIdentifier integerValue]
                                                         message:message.data
                                               completionHandler:^(NFCISO15693ResponseFlag responseFlag, NSData *_Nonnull response, NSError *_Nullable error) {
                                                 if (![self _hasListeners:@"didAuthenticateWithRequestFlags"]) {
                                                   return;
                                                 }
                                                 [self fireEvent:@"didAuthenticateWithRequestFlags"
                                                      withObject:@{
                                                        @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                        @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                        @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                      }];
                                               }];
}

- (void)challengeWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *cryptoSuiteIdentifier = [[args firstObject] valueForKey:@"cryptoSuiteIdentifier"];

  TiBuffer *message = [[args firstObject] valueForKey:@"message"];

  [[self.tagProxy asNFCISO15693Tag] challengeWithRequestFlags:requestFlags
                                        cryptoSuiteIdentifier:[cryptoSuiteIdentifier integerValue]
                                                      message:message.data
                                            completionHandler:^(NSError *_Nullable error) {
                                              if (![self _hasListeners:@"didChallengeWithRequestFlags"]) {
                                                return;
                                              }
                                              [self fireEvent:@"didChallengeWithRequestFlags"
                                                   withObject:@{
                                                     @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                     @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                     @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                   }];
                                            }];
}

- (void)extendedFastReadMultipleBlocksWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] extendedFastReadMultipleBlocksWithRequestFlag:requestFlags
                                                                       blockRange:NSMakeRange(0, 8)
                                                                completionHandler:^(NSArray<NSData *> *_Nonnull dataBlocks, NSError *_Nullable error) {
                                                                  if (![self _hasListeners:@"didExtendedFastReadMultipleBlocksWithRequestFlag"]) {
                                                                    return;
                                                                  }
                                                                  [self fireEvent:@"didExtendedFastReadMultipleBlocksWithRequestFlag"
                                                                       withObject:@{
                                                                         @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                                         @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                                         @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                                       }];
                                                                }];
}

- (void)extendedGetMultipleBlockSecurityStatusWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] extendedGetMultipleBlockSecurityStatusWithRequestFlag:requestFlags
                                                                               blockRange:NSMakeRange(0, 8)
                                                                        completionHandler:^(NSArray<NSNumber *> *_Nonnull securityStatus, NSError *_Nullable error) {
                                                                          if (![self _hasListeners:@"didExtendedGetMultipleBlockSecurityStatusWithRequestFlag"]) {
                                                                            return;
                                                                          }
                                                                          [self fireEvent:@"didExtendedGetMultipleBlockSecurityStatusWithRequestFlag"
                                                                               withObject:@{
                                                                                 @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                                                 @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                                                 @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                                               }];
                                                                        }];
}

- (void)extendedWriteMultipleBlocksWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  TiBuffer *responseDataValue = [[args firstObject] valueForKey:@"dataBlock"];
  NSArray *dataBlock = [[NSArray alloc] initWithObjects:responseDataValue, nil];

  [[self.tagProxy asNFCISO15693Tag] extendedWriteMultipleBlocksWithRequestFlags:requestFlags
                                                                     blockRange:NSMakeRange(0, 8)
                                                                     dataBlocks:dataBlock
                                                              completionHandler:^(NSError *_Nullable error) {
                                                                if (![self _hasListeners:@"didExtendedWriteMultipleBlocksWithRequestFlags"]) {
                                                                  return;
                                                                }
                                                                [self fireEvent:@"didExtendedWriteMultipleBlocksWithRequestFlags"
                                                                     withObject:@{
                                                                       @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                                       @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                                       @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                                     }];
                                                              }];
}

- (void)fastReadMultipleBlocksWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] fastReadMultipleBlocksWithRequestFlag:requestFlags
                                                               blockRange:NSMakeRange(0, 8)
                                                        completionHandler:^(NSArray<NSData *> *_Nonnull dataBlocks, NSError *_Nullable error) {
                                                          if (![self _hasListeners:@"didFastReadMultipleBlocksWithRequestFlag"]) {
                                                            return;
                                                          }
                                                          [self fireEvent:@"didFastReadMultipleBlocksWithRequestFlag"
                                                               withObject:@{
                                                                 @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                                 @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                                 @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                               }];
                                                        }];
}

- (void)getSystemInfoAndUIDWithRequestFlag:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] getSystemInfoAndUIDWithRequestFlag:requestFlags
                                                     completionHandler:^(NSData *_Nullable uid, NSInteger dsfid, NSInteger afi, NSInteger blockSize, NSInteger blockCount, NSInteger icReference, NSError *_Nullable error) {
                                                       if (![self _hasListeners:@"didGetSystemInfoAndUIDWithRequestFlag"]) {
                                                         return;
                                                       }
                                                       [self fireEvent:@"didGetSystemInfoAndUIDWithRequestFlag"
                                                            withObject:@{
                                                              @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                              @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                              @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                            }];
                                                     }];
}

- (void)keyUpdateWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  NSNumber *keyIdentifier = [[args firstObject] valueForKey:@"keyIdentifier"];

  TiBuffer *message = [[args firstObject] valueForKey:@"message"];

  [[self.tagProxy asNFCISO15693Tag] keyUpdateWithRequestFlags:requestFlags
                                                keyIdentifier:[keyIdentifier integerValue]
                                                      message:message.data
                                            completionHandler:^(NFCISO15693ResponseFlag responseFlag, NSData *_Nonnull response, NSError *_Nullable error) {
                                              if (![self _hasListeners:@"didKeyUpdateWithRequestFlags"]) {
                                                return;
                                              }
                                              [self fireEvent:@"didKeyUpdateWithRequestFlags"
                                                   withObject:@{
                                                     @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                     @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                     @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                   }];
                                            }];
}

- (void)readBufferWithRequestFlags:(id)args
{
  NSNumber *requestFlagsValue = [[args firstObject] valueForKey:@"requestFlags"];
  uint8_t requestFlags = [requestFlagsValue unsignedCharValue];

  [[self.tagProxy asNFCISO15693Tag] readBufferWithRequestFlags:requestFlags
                                             completionHandler:^(NFCISO15693ResponseFlag responseFlag, NSData *_Nonnull data, NSError *_Nullable error) {
                                               if (![self _hasListeners:@"didReadBufferWithRequestFlags"]) {
                                                 return;
                                               }
                                               [self fireEvent:@"didReadBufferWithRequestFlags"
                                                    withObject:@{
                                                      @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                      @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                      @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                                    }];
                                             }];
}

- (void)sendRequestWithFlag:(id)args
{
  NSNumber *flag = [[args firstObject] valueForKey:@"flag"];
  NSNumber *commandCode = [[args firstObject] valueForKey:@"commandCode"];

  TiBuffer *data = [[args firstObject] valueForKey:@"data"];

  [[self.tagProxy asNFCISO15693Tag] sendRequestWithFlag:[flag integerValue]
                                            commandCode:[commandCode integerValue]
                                                   data:data.data
                                      completionHandler:^(NFCISO15693ResponseFlag responseFlag, NSData *_Nullable data, NSError *_Nullable error) {
                                        if (![self _hasListeners:@"didReadBufferWithRequestFlags"]) {
                                          return;
                                        }
                                        [self fireEvent:@"didReadBufferWithRequestFlags"
                                             withObject:@{
                                               @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                               @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                               @"errorDomain" : error != nil ? [error domain] : [NSNull null]
                                             }];
                                      }];
}

@end
