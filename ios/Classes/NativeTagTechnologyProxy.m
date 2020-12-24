/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "NativeTagTechnologyProxy.h"
#import "TiBlob.h"
#import "TiNFCTagProxy.h"
#import "TiNfcUtilities.h"
#import "TiUtils.h"

@implementation NativeTagTechnology

#pragma mark Public API's

- (void)connect:(id)unused
{
  [session connectToTag:tag
      completionHandler:^(NSError *_Nullable error) {
        if (error != nil) {
          [self fireEvent:@"didDetectTags"
               withObject:@{
                 @"errorCode" : NUMINTEGER([error code]),
                 @"errorDescription" : [error localizedDescription],
               }];
        } else {
          [self fireEvent:@"didDetectTags"
               withObject:@{
                 @"tag" : [[TiNFCTagProxy alloc] _initWithPageContext:[self pageContext] andTag:tag]
               }];
        }
      }];
}

- (NSNumber *)isConnected:(id)unused
{
  if (session.connectedTag == tag) {
    return [NSNumber numberWithBool:YES];
  } else {
    return [NSNumber numberWithBool:NO];
  }
}
@end
