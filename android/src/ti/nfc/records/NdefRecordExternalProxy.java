/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.records;

import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiBlob;
import org.appcelerator.titanium.util.TiConvert;

import android.nfc.NdefRecord;

import ti.nfc.NfcConstants;
import ti.nfc.NfcModule;
import ti.nfc.api.NdefRecordApi;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = {
	NfcConstants.PROPERTY_DOMAIN, 
	NfcConstants.PROPERTY_DOMAIN_TYPE
})
public class NdefRecordExternalProxy extends NdefRecordProxy 
{
	public NdefRecordExternalProxy() {
		super();
	}
	
	private NdefRecordExternalProxy(NdefRecord record) {
		super(record);
	}
	
	@Override
	public NdefRecord getRecord() {
		String domain = TiConvert.toString(getProperty(NfcConstants.PROPERTY_DOMAIN));
		String type = TiConvert.toString(getProperty(NfcConstants.PROPERTY_DOMAIN_TYPE));
		TiBlob blob = (TiBlob)getProperty(NfcConstants.PROPERTY_PAYLOAD);
		byte[] data;
		if ((blob == null) || !(blob instanceof TiBlob)) {
			data = new byte[0];
		} else {
			data = blob.getBytes();
		}
		
		return NdefRecordApi.getInstance().createExternal(domain, type, data);
	}
	
	public static NdefRecordExternalProxy parse(NdefRecord record) {	
		NdefRecordExternalProxy proxy = new NdefRecordExternalProxy(record);
		
		// URI based on the URN in the type field. The URN is encoded into the 
		// NDEF type field in a shortened form: <domain_name>:<service_name>. 
		// Android maps this to a URI in the form: 
		//    vnd.android.nfc://ext/<domain_name>:<service_name>.
			
		String type = proxy.getType();
		int colon = type.lastIndexOf(':');
		if (colon == -1) {
			proxy.setProperty(NfcConstants.PROPERTY_DOMAIN, type);
			proxy.setProperty(NfcConstants.PROPERTY_DOMAIN_TYPE, "");
		} else {
			proxy.setProperty(NfcConstants.PROPERTY_DOMAIN, type.substring(0, colon));
			proxy.setProperty(NfcConstants.PROPERTY_DOMAIN_TYPE, type.substring(colon + 1));
		}
		
		return proxy;
	}
	
	public static boolean isValid(NdefRecord record) {
		short tnf = record.getTnf();
		return (tnf == NdefRecord.TNF_EXTERNAL_TYPE);
	}
}
