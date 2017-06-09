/**
 * ti.nfc
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Appcelerator
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
