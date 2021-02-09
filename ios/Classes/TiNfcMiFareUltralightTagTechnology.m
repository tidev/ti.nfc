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

// Pragma: Internal

- (NSData *)getCommandData:(NSArray *)StringHex
{
  NSString *input = @"";
  for (NSString *hex in StringHex) {
    input = [input stringByAppendingString:[NSString stringWithFormat:@"0x%lX ", (unsigned long)[hex integerValue]]];
  }
  NSString *output = [input stringByReplacingOccurrencesOfString:@"0x"
                                                      withString:@""
                                                         options:NSCaseInsensitiveSearch
                                                           range:NSMakeRange(0, input.length)];
  NSString *hexChars = @"0123456789abcdefABCDEF";
  NSCharacterSet *hexc = [NSCharacterSet characterSetWithCharactersInString:hexChars];
  NSCharacterSet *invalidHexc = [hexc invertedSet];
  NSString *allHex = [[output componentsSeparatedByCharactersInSet:invalidHexc] componentsJoinedByString:@""];
  NSMutableData *result = [[NSMutableData alloc] init];
  int i = 0;
  for (i = 0; i + 2 <= allHex.length; i += 2) {
    NSRange range = NSMakeRange(i, 2);
    NSString *hexStr = [allHex substringWithRange:range];
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    unsigned int intValue;
    [scanner scanHexInt:&intValue];
    unsigned char uc = (unsigned char)intValue;
    [result appendBytes:&uc length:1];
  }
  NSData *data = [NSData dataWithData:result];
  return data;
}

- (void)sendMiFareCommand:(id)args
{
  NSArray *StringHex = [[args objectAtIndex:0] valueForKey:@"data"];
  NSData *data = [self getCommandData:StringHex];
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
  NSArray *StringHex = [[args objectAtIndex:0] valueForKey:@"data"];
  NSData *data = [self getCommandData:StringHex];

  //Taking uint8_t (unsigned char) value as String and then converting the same into uint8_t.
  NSString *instructionClassValue = [[args firstObject] valueForKey:@"instructionClass"];
  NSData *instructionClassData = [instructionClassValue dataUsingEncoding:NSUTF8StringEncoding];
  const void *instructionClassConst = [instructionClassData bytes];
  uint8_t *instructionClass = (uint8_t *)instructionClassConst;

  NSString *instructionCodeValue = [[args firstObject] valueForKey:@"instructionCode"];
  NSData *instructionCodeData = [instructionCodeValue dataUsingEncoding:NSUTF8StringEncoding];
  const void *instructionCodeConst = [instructionCodeData bytes];
  uint8_t *instructionCode = (uint8_t *)instructionCodeConst;

  NSString *p1ParameterValue = [[args firstObject] valueForKey:@"p1Parameter"];
  NSData *p1ParameterData = [p1ParameterValue dataUsingEncoding:NSUTF8StringEncoding];
  const void *p1ParameterConst = [p1ParameterData bytes];
  uint8_t *p1Parameter = (uint8_t *)p1ParameterConst;

  NSString *p2ParameterValue = [[args firstObject] valueForKey:@"p2Parameter"];
  NSData *p2ParameterData = [p2ParameterValue dataUsingEncoding:NSUTF8StringEncoding];
  const void *p2ParameterConst = [p2ParameterData bytes];
  uint8_t *p2Parameter = (uint8_t *)p2ParameterConst;

  NSNumber *expectedResponseLengthData = [[args objectAtIndex:0] valueForKey:@"expectedResponseLength"];
  NSInteger expectedResponseLength = [expectedResponseLengthData integerValue];

  NFCISO7816APDU *apdu = [[NFCISO7816APDU alloc] initWithInstructionClass:*instructionClass instructionCode:*instructionCode p1Parameter:*p1Parameter p2Parameter:*p2Parameter data:data expectedResponseLength:expectedResponseLength];

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
