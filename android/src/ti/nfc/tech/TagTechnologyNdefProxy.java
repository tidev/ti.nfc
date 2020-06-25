/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.tech;

import android.nfc.FormatException;
import android.nfc.NdefMessage;
import android.nfc.Tag;
import android.nfc.tech.Ndef;
import android.nfc.tech.TagTechnology;
import java.io.IOException;
import org.appcelerator.kroll.annotations.Kroll;
import ti.nfc.NdefMessageProxy;
import ti.nfc.NfcModule;

@Kroll.proxy(creatableInModule = NfcModule.class)
public class TagTechnologyNdefProxy extends TagTechnologyProxy
{
	private Ndef _tag;

	public TagTechnologyNdefProxy()
	{
		super();
	}

	@Override
	public void setTag(Tag tag)
	{
		_tag = Ndef.get(tag);
	}

	@Override
	public TagTechnology getTag()
	{
		return _tag;
	}

	// Tag Technology Methods

	@Kroll.method
	public boolean canMakeReadOnly()
	{
		return _tag.canMakeReadOnly();
	}

	@Kroll.method
	public NdefMessageProxy getCachedNdefMessage()
	{
		NdefMessage message = _tag.getCachedNdefMessage();
		if (message == null) {
			return null;
		}

		return NdefMessageProxy.parse(message);
	}

	@Kroll.method
	public int getMaxSize()
	{
		return _tag.getMaxSize();
	}

	@Kroll.method
	public NdefMessageProxy getNdefMessage() throws IOException, FormatException
	{
		NdefMessage message = _tag.getNdefMessage();
		if (message == null) {
			return null;
		}
		return NdefMessageProxy.parse(message);
	}

	@Kroll.method
	public String getType()
	{
		return _tag.getType();
	}

	@Kroll.method
	public boolean isWritable()
	{
		return _tag.isWritable();
	}

	@Kroll.method
	public boolean makeReadOnly() throws IOException
	{
		return _tag.makeReadOnly();
	}

	@Kroll.method
	public void writeNdefMessage(NdefMessageProxy message) throws IOException, FormatException
	{
		_tag.writeNdefMessage(message.getMessage());
	}
}
