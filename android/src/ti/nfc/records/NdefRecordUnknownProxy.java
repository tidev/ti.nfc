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

@Kroll.proxy
public class NdefRecordUnknownProxy extends NdefRecordProxy
{
	private NdefRecord _record;

	public NdefRecordUnknownProxy()
	{
		super();
	}

	private NdefRecordUnknownProxy(NdefRecord record)
	{
		super(record);
		_record = record;
	}

	@Override
	public NdefRecord getRecord()
	{
		return _record;
	}

	public static NdefRecordUnknownProxy parse(NdefRecord record)
	{
		NdefRecordUnknownProxy proxy = new NdefRecordUnknownProxy(record);

		return proxy;
	}

	public static boolean isValid(NdefRecord record)
	{
		// This is a "catch-all" record type -- all records are supported
		return true;
	}
}
