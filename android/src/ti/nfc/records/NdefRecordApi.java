/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.records;

import android.net.Uri;
import android.nfc.NdefRecord;
import android.os.Build;

public class NdefRecordApi
{
	public static NdefRecord createText(String text, String language, String encoding)
	{
		return NdefRecordSupport.createText(text, language, encoding);
	}

	public static NdefRecord createUri(String uriString)
	{
		return createUri(Uri.parse(uriString));
	}

	public static NdefRecord createApplication(String packageName)
	{
		if (Build.VERSION.SDK_INT >= 14) {
			return NdefRecord.createApplicationRecord(packageName);
		} else {
			return NdefRecordSupport.createApplicationRecord(packageName);
		}
	}

	public static NdefRecord createUri(Uri uri)
	{
		if (Build.VERSION.SDK_INT >= 14) {
			return NdefRecord.createUri(uri);
		} else {
			return NdefRecordSupport.createUri(uri);
		}
	}

	public static NdefRecord createMime(String mimeType, byte[] mimeData)
	{
		if (Build.VERSION.SDK_INT >= 16) {
			return NdefRecord.createMime(mimeType, mimeData);
		} else {
			return NdefRecordSupport.createMime(mimeType, mimeData);
		}
	}

	public static NdefRecord createExternal(String domain, String type, byte[] data)
	{
		if (Build.VERSION.SDK_INT >= 16) {
			return NdefRecord.createExternal(domain, type, data);
		} else {
			return NdefRecordSupport.createExternal(domain, type, data);
		}
	}
}
