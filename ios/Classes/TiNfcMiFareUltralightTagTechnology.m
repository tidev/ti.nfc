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
  return [self.tag asNFCMiFareTag];
}

- (TiBuffer *)identifier
{
  TiBuffer *identifier = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
  NSMutableData *data = [NSMutableData dataWithData:[[self.tag asNFCMiFareTag] identifier]];
  [identifier setData:data];
  return identifier;
}

- (TiBuffer *)historicalBytes
{
  TiBuffer *historicalBytes = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
  NSMutableData *data = [NSMutableData dataWithData:[[self.tag asNFCMiFareTag] historicalBytes]];
  [historicalBytes setData:data];
  return historicalBytes;
}

- (void)sendMiFareCommand:(id)args
{
  TiBuffer *data = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
  data = [[args objectAtIndex:0] valueForKey:@"data"];
  NSMutableData *dataWith = [NSMutableData dataWithData:data];
  NSData *dataValue = [NSData dataWithData:dataWith];

  [[self.tag asNFCMiFareTag] sendMiFareCommand:data
                             completionHandler:^(NSData *response, NSError *error) {
                               TiBuffer *responseData = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
                               NSMutableData *responsevalue = [NSMutableData dataWithData:response];
                               [responseData setData:responsevalue];

                               if (error == nil) {
                                 if (![self _hasListeners:@"didSendMiFareCommand"]) {
                                   return;
                                 }
                                 [self fireEvent:@"didSendMiFareCommand"
                                      withObject:@{
                                        @"errorCode" : NUMINTEGER([error code]),
                                        @"errorDescription" : [error localizedDescription],
                                        @"errorDomain" : [error domain],
                                        @"response" : responseData
                                      }];
                               }
                             }];
}

- (void)sendMiFareISO7816Command:(id)args
{
  TiBuffer *data = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
  data = [[args objectAtIndex:0] valueForKey:@"apdu"];
  NSMutableData *dataWith = [NSMutableData dataWithData:data];
  NFCISO7816APDU *apdu = [NSData dataWithData:dataWith];

  [[self.tag asNFCMiFareTag] sendMiFareISO7816Command:apdu
                                    completionHandler:^(NSData *responseData, uint8_t sw1, uint8_t sw2, NSError *error) {
                                      TiBuffer *responseDataValue = [[TiBuffer alloc] _initWithPageContext:[self pageContext]];
                                      NSMutableData *responsevalue = [NSMutableData dataWithData:responseData];
                                      [responseDataValue setData:responsevalue];
                                      if (error == nil) {
                                        if (![self _hasListeners:@"didSendMiFareISO7816Command"]) {
                                          return;
                                        }
                                        [self fireEvent:@"didSendMiFareISO7816Command"
                                             withObject:@{
                                               @"errorCode" : NUMINTEGER([error code]),
                                               @"errorDescription" : [error localizedDescription],
                                               @"errorDomain" : [error domain],
                                               @"responseData" : responseDataValue
                                             }];
                                      }
                                    }];
}
@end
