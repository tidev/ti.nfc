/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import <CoreNFC/CoreNFC.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagTechnology : TiProxy

- (void)connect:(id)args;

- (NSNumber *)isConnected:(id)args;

- (void)close:(id)unused;

- (void)restartPolling:(id)unused;

- (NSNumber *)isEnabled:(id)unused;


@end

NS_ASSUME_NONNULL_END
