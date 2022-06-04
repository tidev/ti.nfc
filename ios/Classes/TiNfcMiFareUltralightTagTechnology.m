/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcMiFareUltralightTagTechnology.h"

@implementation TiNfcMiFareUltralightTagTechnology

- (NSNumber *)mifareFamily
{
  return [self.tagProxy asNFCMiFareTag];
}

- (TiBuffer *)identifier
{
  TiBuffer *identifier = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
  NSMutableData *data = [NSMutableData dataWithData:[[self.tagProxy asNFCMiFareTag] identifier]];
  [identifier setData:data];
  return identifier;
}

- (TiBuffer *)historicalBytes
{
  TiBuffer *historicalBytes = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
  NSMutableData *data = [NSMutableData dataWithData:[[self.tagProxy asNFCMiFareTag] historicalBytes]];
  [historicalBytes setData:data];
  return historicalBytes;
}

- (void)sendMiFareCommand:(id)args
{
  NSArray *commandData = [[args firstObject] valueForKey:@"data"];
  unsigned int dataValue[commandData.count];
  for (int i = 0; i < commandData.count; i++) {
    dataValue[i] = [commandData[i] unsignedIntValue];
  }
  NSData *data = [[NSData alloc] initWithBytes:dataValue length:commandData.count];
  [[self.tagProxy asNFCMiFareTag] sendMiFareCommand:data
                                  completionHandler:^(NSData *response, NSError *error) {
                                    if (![self _hasListeners:@"didSendMiFareCommand"]) {
                                      return;
                                    }
                                    TiBuffer *responseData = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
                                    NSMutableData *responsevalue = [NSMutableData dataWithData:response];
                                    [responseData setData:responsevalue];
                                    [self fireEvent:@"didSendMiFareCommand"
                                         withObject:@{
                                           @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                           @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                           @"errorDomain" : error != nil ? [error domain] : [NSNull null],
                                           @"responseDataLength" : responseData.length

                                         }];
                                  }];
}

- (void)sendMiFareISO7816Command:(id)args
{
  NSArray *commandData = [[args firstObject] valueForKey:@"data"];
  unsigned int dataValue[commandData.count];
  for (int i = 0; i < commandData.count; i++) {
    dataValue[i] = [commandData[i] unsignedIntValue];
  }
  NSData *data = [[NSData alloc] initWithBytes:dataValue length:commandData.count];

  NSNumber *instructionClassValue = [[args firstObject] valueForKey:@"instructionClass"];
  uint8_t instructionClass = [instructionClassValue unsignedCharValue];

  NSNumber *instructionCodeValue = [[args firstObject] valueForKey:@"instructionCode"];
  uint8_t instructionCode = [instructionCodeValue unsignedCharValue];

  NSNumber *p1ParameterValue = [[args firstObject] valueForKey:@"p1Parameter"];
  uint8_t p1Parameter = [p1ParameterValue unsignedCharValue];

  NSNumber *p2ParameterValue = [[args firstObject] valueForKey:@"p2Parameter"];
  uint8_t p2Parameter = [p2ParameterValue unsignedCharValue];

  NSNumber *expectedResponseLengthData = [[args firstObject] valueForKey:@"expectedResponseLength"];
  NSInteger expectedResponseLength = [expectedResponseLengthData integerValue];

  NFCISO7816APDU *apdu = [[NFCISO7816APDU alloc] initWithInstructionClass:instructionClass instructionCode:instructionCode p1Parameter:p1Parameter p2Parameter:p2Parameter data:data expectedResponseLength:expectedResponseLength];

  [[self.tagProxy asNFCMiFareTag] sendMiFareISO7816Command:apdu
                                         completionHandler:^(NSData *responseData, uint8_t sw1, uint8_t sw2, NSError *error) {
                                           if (![self _hasListeners:@"didSendMiFareISO7816Command"]) {
                                             return;
                                           }
                                           TiBuffer *responseDataValue = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
                                           NSMutableData *responsevalue = [NSMutableData dataWithData:responseData];
                                           [responseDataValue setData:responsevalue];
                                           [self fireEvent:@"didSendMiFareISO7816Command"
                                                withObject:@{
                                                  @"errorCode" : error != nil ? NUMINTEGER([error code]) : [NSNull null],
                                                  @"errorDescription" : error != nil ? [error localizedDescription] : [NSNull null],
                                                  @"errorDomain" : error != nil ? [error domain] : [NSNull null],
                                                  @"responseDataLength" : responseDataValue.length

                                                }];
                                         }];
}
@end
