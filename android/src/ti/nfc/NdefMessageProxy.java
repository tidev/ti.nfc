/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc;

import android.nfc.NdefMessage;
import android.nfc.NdefRecord;
import android.os.Parcelable;
import java.util.ArrayList;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiBlob;
import ti.nfc.records.NdefRecordProxy;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = { NfcConstants.PROPERTY_RECORDS })
public class NdefMessageProxy extends KrollProxy
{
	public static NdefMessageProxy parse(NdefMessage ndefMessage)
	{
		NdefMessageProxy proxy = new NdefMessageProxy();
		NdefRecord[] records = ndefMessage.getRecords();
		ArrayList<NdefRecordProxy> proxies = new ArrayList<NdefRecordProxy>();
		for (NdefRecord rec : records) {
			proxies.add(NdefRecordProxy.parse(rec));
		}
		proxy.setProperty(NfcConstants.PROPERTY_RECORDS, proxies.toArray(new NdefRecordProxy[proxies.size()]));

		return proxy;
	}

	public static NdefMessageProxy[] parse(Parcelable[] messages)
	{
		ArrayList<NdefMessageProxy> proxies = new ArrayList<NdefMessageProxy>();
		if (messages != null) {
			for (int i = 0; i < messages.length; i++) {
				proxies.add(parse((NdefMessage) messages[i]));
			}
		}
		return proxies.toArray(new NdefMessageProxy[proxies.size()]);
	}

	public NdefMessage getMessage()
	{
		ArrayList<NdefRecord> ndefRecords = new ArrayList<NdefRecord>();
		Object prop = getProperty(NfcConstants.PROPERTY_RECORDS);
		if (prop instanceof Object[]) {
			Object[] records = (Object[]) prop;
			for (Object rec : records) {
				if (rec instanceof NdefRecordProxy) {
					NdefRecordProxy record = (NdefRecordProxy) rec;
					ndefRecords.add(record.getRecord());
				}
			}
		}

		return new NdefMessage(ndefRecords.toArray(new NdefRecord[ndefRecords.size()]));
	}

	@Kroll.method
	public TiBlob toByte()
	{
		// This method must realize the actual message object so that it can
		// return the byte array and create the blob.
		return TiBlob.blobFromData(getMessage().toByteArray());
	}
}
