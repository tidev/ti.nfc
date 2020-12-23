/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TagTechnologyProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface NativeTagTechnology : TagTechnology {
  NFCTagReaderSession *session;
  id<NFCTag> tag;
}

@end

NS_ASSUME_NONNULL_END
