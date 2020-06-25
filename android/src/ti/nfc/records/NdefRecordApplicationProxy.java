/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.records;

import android.nfc.NdefRecord;
import java.nio.charset.Charset;
import java.util.Arrays;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.util.TiConvert;
import ti.nfc.NfcConstants;
import ti.nfc.NfcModule;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = { NfcConstants.PROPERTY_PACKAGE_NAME })
public class NdefRecordApplicationProxy extends NdefRecordProxy
{
	public NdefRecordApplicationProxy()
	{
		super();
	}

	private NdefRecordApplicationProxy(NdefRecord record)
	{
		super(record);
	}

	@Override
	public NdefRecord getRecord()
	{
		String packageName = TiConvert.toString(getProperty(NfcConstants.PROPERTY_PACKAGE_NAME));

		return NdefRecordApi.createApplication(packageName);
	}

	public static NdefRecordApplicationProxy parse(NdefRecord record)
	{
		NdefRecordApplicationProxy proxy = new NdefRecordApplicationProxy(record);

		proxy.setProperty(NfcConstants.PROPERTY_PACKAGE_NAME,
						  new String(record.getPayload(), Charset.forName("UTF-8")));

		return proxy;
	}

	public static boolean isValid(NdefRecord record)
	{
		short tnf = record.getTnf();
		return ((tnf == NdefRecord.TNF_EXTERNAL_TYPE)
				&& (Arrays.equals(record.getType(), NdefRecordSupport.RTD_ANDROID_APP)));
	}
}
