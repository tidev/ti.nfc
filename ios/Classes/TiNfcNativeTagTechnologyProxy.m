//
//  TiNfcNativeTagTechnologyProxy.m
//  ti.nfc
//
//  Created by Anil Shukla on 13/01/21.
//

#import "TiNfcNativeTagTechnologyProxy.h"
#import "TiBlob.h"
#import "TiNfcTagProxy.h"
#import "TiNfcUtilities.h"
#import "TiUtils.h"

@implementation TiNfcNativeTagTechnologyProxy

#pragma mark Public API's

- (void)connect:(id)unused
{
  [session connectToTag:tag
      completionHandler:^(NSError *_Nullable error) {
        if (![self _hasListeners:@"didConnectTag"]) {
          return;
        }
        [self fireEvent:@"didConnectTag"
             withObject:@{
               @"errorCode" : NUMINTEGER([error code]),
               @"errorDescription" : [error localizedDescription],
               @"errorDomain" : [error domain],
               @"tag" : [[TiNfcTagProxy alloc] _initWithPageContext:[self pageContext] andTag:tag]
             }];
      }];
}

- (NSNumber *)isConnected:(id)unused
{
  return [NSNumber numberWithBool:session.connectedTag == tag ? YES : NO];
}

@end
