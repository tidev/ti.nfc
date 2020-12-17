/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TagTechnologyProxy.h"
#import "TiBlob.h"
#import "TiNfcUtilities.h"
#import "TiUtils.h"

@implementation TagTechnology

#pragma mark Public API's

- (void)connect:(id)unused
{
}

- (void)close:(id)unused
{
}

- (void)restartPolling:(id)unused
{
}

- (NSNumber *)isConnected:(id)unused
{
  return [NSNumber numberWithBool:NO];
}

- (NSNumber *)isEnabled:(id)unused
{
  return [NSNumber numberWithBool:NO];
}

@end
