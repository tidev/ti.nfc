/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcNativeTagTechnologyProxy.h"
#import "TiBlob.h"
#import "TiNfcTagProxy.h"
#import "TiNfcUtilities.h"
#import "TiUtils.h"

@implementation TiNfcNativeTagTechnologyProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andSession:(NFCTagReaderSession *)session andTag:(TiNfcTagProxy *)tag
{
  if (self = [super _initWithPageContext:context]) {
    self.tag = tag;
    self.session = session;
  }
  return self;
}

#pragma mark Public API's

- (void)connect:(id)unused
{
  [self.session connectToTag:self.tag.tag
           completionHandler:^(NSError *_Nullable error) {
             if (![self _hasListeners:@"didConnectTag"]) {
               return;
             }
             [self fireEvent:@"didConnectTag"
                  withObject:@{
                    @"errorCode" : NUMINTEGER([error code]),
                    @"errorDescription" : [error localizedDescription],
                    @"errorDomain" : [error domain],
                    @"tag" : self.tag
                  }];
           }];
}

- (NSNumber *)isConnected:(id)unused
{
  return [NSNumber numberWithBool:self.session.connectedTag == self.tag.tag ? YES : NO];
}

@end
