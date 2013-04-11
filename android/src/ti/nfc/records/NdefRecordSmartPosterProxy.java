/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.records;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Locale;

import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiBlob;
import org.appcelerator.titanium.util.TiConvert;

import ti.nfc.NfcConstants;
import ti.nfc.NdefMessageProxy;
import ti.nfc.NfcModule;

import android.nfc.FormatException;
import android.nfc.NdefMessage;
import android.nfc.NdefRecord;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = {
	NfcConstants.PROPERTY_TITLE,
	NfcConstants.PROPERTY_URI,
	NfcConstants.PROPERTY_ACTION,
	NfcConstants.PROPERTY_MIME_TYPE
})
public class NdefRecordSmartPosterProxy extends NdefRecordProxy 
{
    private static final byte[] ACTION_RECORD_TYPE = new byte[] {'a', 'c', 't'};
    private static final String ACTION_RECORD_TYPE_STR = "act";
    private static final byte[] TYPE_TYPE = new byte[] { 't' };
    private static final String TYPE_TYPE_STR = "t";

	public NdefRecordSmartPosterProxy() {
		super();
	}
	
	private NdefRecordSmartPosterProxy(NdefRecord record) {
		super(record);
	}
	
	@Override
	public NdefRecord getRecord() {
		ArrayList<NdefRecord> records = new ArrayList<NdefRecord>();
		if (hasProperty(NfcConstants.PROPERTY_TITLE)) {
			String title = TiConvert.toString(getProperty(NfcConstants.PROPERTY_TITLE));
			String language = Locale.getDefault().getLanguage();
			String encoding = NfcModule.ENCODING_UTF8;
			records.add(NdefRecordApi.createText(title, language, encoding));
		} 
		if (hasProperty(NfcConstants.PROPERTY_URI)) {
			String uri = TiConvert.toString(getProperty(NfcConstants.PROPERTY_URI));
			records.add(NdefRecordApi.createUri(uri));
		}
		if (hasProperty(NfcConstants.PROPERTY_ACTION)) {
			byte action = (byte)TiConvert.toInt(getProperty(NfcConstants.PROPERTY_ACTION));
			records.add(new NdefRecord(NdefRecord.TNF_MIME_MEDIA,
					ACTION_RECORD_TYPE, new byte[0], new byte[]{ action }));
		}
		if (hasProperty(NfcConstants.PROPERTY_MIME_TYPE)) {
			String mimeType = TiConvert.toString(getProperty(NfcConstants.PROPERTY_MIME_TYPE));
			records.add(new NdefRecord(NdefRecord.TNF_MIME_MEDIA,
					TYPE_TYPE, new byte[0], mimeType.getBytes(Charset.forName("US_ASCII"))));
		}
		
		NdefMessage message = new NdefMessage(records.toArray(new NdefRecord[records.size()]));
		
		return new NdefRecord(NdefRecord.TNF_WELL_KNOWN, NdefRecord.RTD_SMART_POSTER,
				new byte[0], message.toByteArray());
	}
	
	public static NdefRecordSmartPosterProxy parse(NdefRecord record) {
		NdefRecordSmartPosterProxy proxy = new NdefRecordSmartPosterProxy(record);
		
		try {
			NdefMessage subRecords = new NdefMessage(record.getPayload());
			NdefMessageProxy message = NdefMessageProxy.parse(subRecords);
			NdefRecordProxy[] records = (NdefRecordProxy[])message.getProperty(NfcConstants.PROPERTY_RECORDS);
			if (records != null) {
				for (NdefRecordProxy rec : records) {
					if (rec instanceof NdefRecordTextProxy) {
						proxy.setProperty(NfcConstants.PROPERTY_TITLE, rec.getProperty(NfcConstants.PROPERTY_TEXT));
					} else if (rec instanceof NdefRecordUriProxy) {
						proxy.setProperty(NfcConstants.PROPERTY_URI, rec.getProperty(NfcConstants.PROPERTY_URI));
					} else if (rec instanceof NdefRecordMediaProxy) {
						TiBlob blob = (TiBlob)rec.getProperty(NfcConstants.PROPERTY_PAYLOAD);
						byte[] payload = blob.getBytes();
						if (ACTION_RECORD_TYPE_STR.equals(rec.getType())) {
							proxy.setProperty(NfcConstants.PROPERTY_ACTION, payload[0]);
						} else if (TYPE_TYPE_STR.equals(rec.getType())) {
							proxy.setProperty(NfcConstants.PROPERTY_MIME_TYPE, new String(payload, Charset.forName("UTF-8")));
						}
					}
				}
			}
			
			
		} catch (FormatException e) {
			throw new IllegalArgumentException(e);
		}
		
		return proxy;
	}
	
	public static boolean isValid(NdefRecord record) {
		short tnf = record.getTnf();
		return ((tnf == NdefRecord.TNF_WELL_KNOWN) && 
				(Arrays.equals(record.getType(), NdefRecord.RTD_SMART_POSTER)));
	}
}
