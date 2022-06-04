/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc;

import android.nfc.Tag;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;

@Kroll.proxy
public class NfcTagProxy extends KrollProxy
{
	private Tag _tag;

	public NfcTagProxy(Tag tag)
	{
		super();
		_tag = tag;
	}

	public Tag getTag()
	{
		return _tag;
	}

	@Kroll.getProperty
	@Kroll.method
	public String getId()
	{
		String result = null;
		byte[] id = _tag.getId();
		if (id != null) {
			result = bytesToString(id).toString();
		}
		return result;
	}

	@Kroll.getProperty
	@Kroll.method
	public String[] getTechList()
	{
		return _tag.getTechList();
	}

	private static StringBuilder bytesToString(byte[] bs)
	{
		StringBuilder s = new StringBuilder();
		for (byte b : bs) {
			s.append(String.format("%02X", b));
		}
		return s;
	}
}