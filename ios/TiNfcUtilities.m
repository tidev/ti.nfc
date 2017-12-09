//
//  TiNfcUtilities.m
//  ti.nfc
//
//  Created by Hans Knöchel on 10.10.17.
//

#import "TiNfcUtilities.h"

@implementation TiNfcUtilities

+ (NSString *)typeFromNDEFData:(NSData *)NDEFData
{
  NSString *firstByte = [TiNfcUtilities _firstByteFromData:NDEFData];
  
  if ([firstByte isEqualToString:@"00"]) {
    return @"None";
  } else if ([firstByte isEqualToString:@"01"]) {
    return @"http://www.";
  } else if ([firstByte isEqualToString:@"02"]) {
    return @"https://www.";
  } else if ([firstByte isEqualToString:@"03"]) {
    return @"http://";
  } else if ([firstByte isEqualToString:@"04"]) {
    return @"https://";
  } else if ([firstByte isEqualToString:@"05"]) {
    return @"tel:";
  } else if ([firstByte isEqualToString:@"06"]) {
    return @"mailto:";
  } else if ([firstByte isEqualToString:@"07"]) {
    return @"ftp://anonymous:anonymous@";
  } else if ([firstByte isEqualToString:@"08"]) {
    return @"ftp://ftp.";
  } else if ([firstByte isEqualToString:@"09"]) {
    return @"ftps://";
  } else if ([firstByte isEqualToString:@"0A"]) {
    return @"sftp://";
  } else if ([firstByte isEqualToString:@"0B"]) {
    return @"smb://";
  } else if ([firstByte isEqualToString:@"0C"]) {
    return @"nfs://";
  } else if ([firstByte isEqualToString:@"0D"]) {
    return @"ftp://";
  } else if ([firstByte isEqualToString:@"0E"]) {
    return @"dav://";
  } else if ([firstByte isEqualToString:@"0F"]) {
    return @"news:";
  } else if ([firstByte isEqualToString:@"10"]) {
    return @"telnet://";
  } else if ([firstByte isEqualToString:@"11"]) {
    return @"imap:";
  } else if ([firstByte isEqualToString:@"12"]) {
    return @"rtsp://";
  } else if ([firstByte isEqualToString:@"13"]) {
    return @"urn:";
  } else if ([firstByte isEqualToString:@"14"]) {
    return @"pop:";
  } else if ([firstByte isEqualToString:@"15"]) {
    return @"sip:";
  } else if ([firstByte isEqualToString:@"16"]) {
    return @"sips:";
  } else if ([firstByte isEqualToString:@"17"]) {
    return @"tftp:";
  } else if ([firstByte isEqualToString:@"18"]) {
    return @"btspp://";
  } else if ([firstByte isEqualToString:@"19"]) {
    return @"btl2cap://";
  } else if ([firstByte isEqualToString:@"1A"]) {
    return @"btgoep://";
  } else if ([firstByte isEqualToString:@"1B"]) {
    return @"tcpobex://";
  } else if ([firstByte isEqualToString:@"1C"]) {
    return @"irdaobex://";
  } else if ([firstByte isEqualToString:@"1D"]) {
    return @"file://";
  } else if ([firstByte isEqualToString:@"1E"]) {
    return @"urn:epc:id:";
  } else if ([firstByte isEqualToString:@"1F"]) {
    return @"urn:epc:tag:";
  } else if ([firstByte isEqualToString:@"20"]) {
    return @"urn:epc:pat:";
  } else if ([firstByte isEqualToString:@"21"]) {
    return @"urn:epc:raw:";
  } else if ([firstByte isEqualToString:@"22"]) {
    return @"urn:epc:";
  } else if ([firstByte isEqualToString:@"23"]) {
    return @"urn:nfc:";
  }
  
  return @"";
}

+ (NSString *)NDEFContentFromData:(NSData *)data
{
  NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  return [dataString substringFromIndex:2];
}

+ (NSString *)_firstByteFromData:(NSData *)data
{
  return [[TiNfcUtilities _dataToHexString:data] substringToIndex:2];
}

+ (NSString *)_dataToHexString:(NSData *)data;
{
  // get the length of the data
  NSUInteger bytesCount = data.length;
  if (bytesCount) {
    // string with all the Hex characters
    const char *hexChars = "0123456789ABCDEF";
    // put bytes into an array and initialize the response array
    const unsigned char *dataBuffer = data.bytes;
    char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
    char *s = chars;
    // go through data bytes making the transformations so a hex will literally translate to a string, so for example 0x0A will translate to "0A"
    for (unsigned i = 0; i < bytesCount; ++i) {
      // get hexChars character at binary AND between the current byte and 0xF0 bitwise to the right by 4 index and assign it to the current chars pointer
      *s++ = hexChars[((*dataBuffer & 0xF0) >> 4)];
      // get hexChars character at binary AND between the current byte and 0x0F index and assign it to the current chars pointer
      *s++ = hexChars[(*dataBuffer & 0x0F)];
      dataBuffer++;
    }
    *s = '\0';
    // chars to string
    NSString *hexString = [NSString stringWithUTF8String:chars];
    free(chars);
    return hexString;
  }
  return @"";
}

@end
