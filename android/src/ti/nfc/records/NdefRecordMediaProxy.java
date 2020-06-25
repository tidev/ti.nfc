/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.records;

import android.nfc.NdefRecord;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiBlob;
import org.appcelerator.titanium.util.TiConvert;
import ti.nfc.NfcConstants;
import ti.nfc.NfcModule;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = { NfcConstants.PROPERTY_MIME_TYPE })
public class NdefRecordMediaProxy extends NdefRecordProxy
{
	public NdefRecordMediaProxy()
	{
		super();
	}

	private NdefRecordMediaProxy(NdefRecord record)
	{
		super(record);
	}

	@Override
	public NdefRecord getRecord()
	{
		TiBlob blob = (TiBlob) getProperty(NfcConstants.PROPERTY_PAYLOAD);
		byte[] data;
		if ((blob == null) || !(blob instanceof TiBlob)) {
			data = new byte[0];
		} else {
			data = blob.getBytes();
		}
		String mimeType = TiConvert.toString(getProperty(NfcConstants.PROPERTY_MIME_TYPE));
		if (mimeType == null) {
			mimeType = blob.getMimeType();
		}

		return NdefRecordApi.createMime(mimeType, data);
	}

	public static NdefRecordMediaProxy parse(NdefRecord record)
	{
		NdefRecordMediaProxy proxy = new NdefRecordMediaProxy(record);

		proxy.setProperty(NfcConstants.PROPERTY_MIME_TYPE, proxy.getType());
		proxy.setProperty(NfcConstants.PROPERTY_PAYLOAD, TiBlob.blobFromData(record.getPayload(), proxy.getType()));

		return proxy;
	}

	public static boolean isValid(NdefRecord record)
	{
		short tnf = record.getTnf();
		return (tnf == NdefRecord.TNF_MIME_MEDIA);
	}
}
