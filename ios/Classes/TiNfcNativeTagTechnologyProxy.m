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

- (id)_initWithPageContext:(id<TiEvaluator>)context andTag:(TiNfcTagProxy *)tag
{
  if (self = [super _initWithPageContext:context]) {
    tag = tag;
  }
  return self;
}

#pragma mark Public API's

- (void)connect:(id)unused
{
  [session connectToTag:tag.tag
      completionHandler:^(NSError *_Nullable error) {
        if (![self _hasListeners:@"didConnectTag"]) {
          return;
        }
        [self fireEvent:@"didConnectTag"
             withObject:@{
               @"errorCode" : NUMINTEGER([error code]),
               @"errorDescription" : [error localizedDescription],
               @"errorDomain" : [error domain],
               @"tag" : [[TiNfcTagProxy alloc] _initWithPageContext:[self pageContext] andTag:tag.tag]
             }];
      }];
}

- (NSNumber *)isConnected:(id)unused
{
  return [NSNumber numberWithBool:session.connectedTag == tag.tag ? YES : NO];
}

@end
