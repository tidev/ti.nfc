/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.records;

import java.nio.charset.Charset;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiBlob;

import ti.nfc.NfcConstants;

import android.nfc.NdefRecord;

@Kroll.proxy(propertyAccessors = {
	NfcConstants.PROPERTY_PAYLOAD
})
public abstract class NdefRecordProxy extends KrollProxy 
{
	private String _id;
	private short _tnf;
	private String _type;
	private int _hashCode;

	public NdefRecordProxy() {
		super();
	}
	
	protected NdefRecordProxy(NdefRecord record) {
		this();
		
		byte[] id = record.getId();
		if (id != null) {
			_id = bytesToString(id).toString();
		}
		_tnf = record.getTnf();
		
		byte[] type = record.getType();
		if (type != null) {
			_type = new String(type, Charset.forName("UTF-8"));
		}
		_hashCode = record.hashCode();	
		
		byte[] payload = record.getPayload();
		if (payload != null) {
			setProperty(NfcConstants.PROPERTY_PAYLOAD, TiBlob.blobFromData(payload, _type));
		}
	}

	public abstract NdefRecord getRecord();
	
	public static NdefRecordProxy parse(NdefRecord record) {
		if (NdefRecordUriProxy.isValid(record)) {
			return NdefRecordUriProxy.parse(record);
		} else if (NdefRecordTextProxy.isValid(record)) {
			return NdefRecordTextProxy.parse(record);
		} else if (NdefRecordMediaProxy.isValid(record)) {
			return NdefRecordMediaProxy.parse(record);
		} else if (NdefRecordExternalProxy.isValid(record)) {
			return NdefRecordExternalProxy.parse(record);
		} else if (NdefRecordSmartPosterProxy.isValid(record)) {
			return NdefRecordSmartPosterProxy.parse(record);
		} else if (NdefRecordApplicationProxy.isValid(record)) {
			return NdefRecordApplicationProxy.parse(record);
		} else if (NdefRecordEmptyProxy.isValid(record)) {
			return NdefRecordEmptyProxy.parse(record);
		} else {
			return NdefRecordUnknownProxy.parse(record);
		}
	}
	
	@Kroll.getProperty @Kroll.method
	public String getRecordType() {
		// Get the current class name and remove the "Proxy" suffix
		String name = getClass().getSimpleName();
		return name.substring(0, name.lastIndexOf("Proxy"));
	}
	
	@Kroll.getProperty @Kroll.method
	public String getId() {
		return _id;
	}
	
	@Kroll.getProperty @Kroll.method
	public short getTnf() {
		return _tnf;
	}
	
	@Kroll.getProperty @Kroll.method
	public String getType() {
		return _type;
	}
	
	@Kroll.getProperty @Kroll.method
	public int getHashCode() {
		return _hashCode;
	}

    private static StringBuilder bytesToString(byte[] bs) {
        StringBuilder s = new StringBuilder();
        for (byte b : bs) {
            s.append(String.format("%02X", b));
        }
        return s;
    }
}
