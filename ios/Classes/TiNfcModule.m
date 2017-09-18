/**
 * Ti.NFC
 * Copyright (c) 2009-2017 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiNfcModule

#pragma mark Internal

- (id)moduleGUID
{
	return @"e6caa17f-c084-402c-be84-8df242d94eba";
}

- (NSString *)moduleId
{
	return @"ti.nfc";
}

#pragma mark Lifecycle

- (void)startup
{
	[super startup];

	NSLog(@"[DEBUG] %@ loaded",self);
}
    
#pragma Public APIs

@end
