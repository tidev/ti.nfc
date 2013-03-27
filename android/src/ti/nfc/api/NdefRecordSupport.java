/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

/* 
 * Portions of this file include the Android Open Source Project [http://source.android.com]
 * 
 * Copyright (C) 2010 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Code modified from the api level 14 NdefRecord.java file with Titanium-specific modifications.
 */

package ti.nfc.api;

import java.nio.charset.Charset;
import java.util.Locale;

import android.net.Uri;
import android.nfc.NdefRecord;

public class NdefRecordSupport {
    /**
     * NFC Forum "URI Record Type Definition"<p>
     * This is a mapping of "URI Identifier Codes" to URI string prefixes,
     * per section 3.2.2 of the NFC Forum URI Record Type Definition document.
     */
    public static final String[] URI_PREFIX_MAP = new String[] {
            "", // 0x00
            "http://www.", // 0x01
            "https://www.", // 0x02
            "http://", // 0x03
            "https://", // 0x04
            "tel:", // 0x05
            "mailto:", // 0x06
            "ftp://anonymous:anonymous@", // 0x07
            "ftp://ftp.", // 0x08
            "ftps://", // 0x09
            "sftp://", // 0x0A
            "smb://", // 0x0B
            "nfs://", // 0x0C
            "ftp://", // 0x0D
            "dav://", // 0x0E
            "news:", // 0x0F
            "telnet://", // 0x10
            "imap:", // 0x11
            "rtsp://", // 0x12
            "urn:", // 0x13
            "pop:", // 0x14
            "sip:", // 0x15
            "sips:", // 0x16
            "tftp:", // 0x17
            "btspp://", // 0x18
            "btl2cap://", // 0x19
            "btgoep://", // 0x1A
            "tcpobex://", // 0x1B
            "irdaobex://", // 0x1C
            "file://", // 0x1D
            "urn:epc:id:", // 0x1E
            "urn:epc:tag:", // 0x1F
            "urn:epc:pat:", // 0x20
            "urn:epc:raw:", // 0x21
            "urn:epc:", // 0x22
            "urn:nfc:" // 0x23
    };
    
    public static final byte[] RTD_ANDROID_APP = "android.com:pkg".getBytes();
    
	public static NdefRecord createText(String text, String language, String encoding) {
		Charset utfEncoding = Charset.forName(encoding);
        byte[] langBytes = language.getBytes(utfEncoding);
        byte[] textBytes = text.getBytes(utfEncoding);

        int utfBit = (encoding.equalsIgnoreCase("UTF-8")) ? 0 : (1 << 7);
        char status = (char) (utfBit + langBytes.length);

        byte[] data = new byte[1 + langBytes.length + textBytes.length]; 
        data[0] = (byte) status;
        System.arraycopy(langBytes, 0, data, 1, langBytes.length);
        System.arraycopy(textBytes, 0, data, 1 + langBytes.length, textBytes.length);

        return new NdefRecord(NdefRecord.TNF_WELL_KNOWN, NdefRecord.RTD_TEXT, new byte[0], data);
    }
	
    public static NdefRecord createApplicationRecord(String packageName) {
        if (packageName == null) throw new NullPointerException("packageName is null");
        if (packageName.length() == 0) throw new IllegalArgumentException("packageName is empty");

        return new NdefRecord(NdefRecord.TNF_EXTERNAL_TYPE, RTD_ANDROID_APP, new byte[0], packageName.getBytes(Charset.forName("UTF_8")));
    }

    public static NdefRecord createUri(Uri uri) {
        if (uri == null) throw new NullPointerException("uri is null");

        // NOT AVAILABLE UNTIL API level 16 // uri = uri.normalizeScheme();
        String uriString = uri.toString();
        if (uriString.length() == 0) throw new IllegalArgumentException("uri is empty");

        byte prefix = 0;
        for (int i = 1; i < URI_PREFIX_MAP.length; i++) {
            if (uriString.startsWith(URI_PREFIX_MAP[i])) {
                prefix = (byte) i;
                uriString = uriString.substring(URI_PREFIX_MAP[i].length());
                break;
            }
        }
        byte[] uriBytes = uriString.getBytes(Charset.forName("UTF_8"));
        byte[] recordBytes = new byte[uriBytes.length + 1];
        recordBytes[0] = prefix;
        System.arraycopy(uriBytes, 0, recordBytes, 1, uriBytes.length);
        return new NdefRecord(NdefRecord.TNF_WELL_KNOWN, NdefRecord.RTD_URI, new byte[0], recordBytes);
    }

    public static NdefRecord createUri(String uriString) {
        return createUri(Uri.parse(uriString));
    }

    public static NdefRecord createMime(String mimeType, byte[] mimeData) {
        if (mimeType == null) throw new NullPointerException("mimeType is null");

        // We only do basic MIME type validation: trying to follow the
        // RFCs strictly only ends in tears, since there are lots of MIME
        // types in common use that are not strictly valid as per RFC rules
        // NOT AVAILABLE UNTIL API level 16 // mimeType = TiApplication.getAppRootOrCurrentActivity().getIntent().normalizeMimeType(mimeType);
        if (mimeType.length() == 0) throw new IllegalArgumentException("mimeType is empty");
        int slashIndex = mimeType.indexOf('/');
        if (slashIndex == 0) throw new IllegalArgumentException("mimeType must have major type");
        if (slashIndex == mimeType.length() - 1) {
            throw new IllegalArgumentException("mimeType must have minor type");
        }
        // missing '/' is allowed

        // MIME RFCs suggest ASCII encoding for content-type
        byte[] typeBytes = mimeType.getBytes(Charset.forName("US_ASCII"));
        return new NdefRecord(NdefRecord.TNF_MIME_MEDIA, typeBytes, new byte[0], mimeData);
    }

    public static NdefRecord createExternal(String domain, String type, byte[] data) {
        if (domain == null) throw new NullPointerException("domain is null");
        if (type == null) throw new NullPointerException("type is null");

        domain = domain.trim().toLowerCase(Locale.US);
        type = type.trim().toLowerCase(Locale.US);

        if (domain.length() == 0) throw new IllegalArgumentException("domain is empty");
        if (type.length() == 0) throw new IllegalArgumentException("type is empty");

        byte[] byteDomain = domain.getBytes(Charset.forName("UTF_8"));
        byte[] byteType = type.getBytes(Charset.forName("UTF_8"));
        byte[] b = new byte[byteDomain.length + 1 + byteType.length];
        System.arraycopy(byteDomain, 0, b, 0, byteDomain.length);
        b[byteDomain.length] = ':';
        System.arraycopy(byteType, 0, b, byteDomain.length + 1, byteType.length);

        return new NdefRecord(NdefRecord.TNF_EXTERNAL_TYPE, b, new byte[0], data);
    }
}
