/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.tech;

import java.io.IOException;

import org.appcelerator.kroll.annotations.Kroll;

import ti.nfc.NdefMessageProxy;
import ti.nfc.NfcModule;

import android.nfc.FormatException;
import android.nfc.Tag;
import android.nfc.tech.NdefFormatable;
import android.nfc.tech.TagTechnology;

@Kroll.proxy(creatableInModule = NfcModule.class)
public class TagTechnologyNdefFormatableProxy extends TagTechnologyProxy 
{
	private NdefFormatable _tag;
	
	public TagTechnologyNdefFormatableProxy() {
		super();
	}
	
	@Override
	public void setTag(Tag tag) {
		_tag = NdefFormatable.get(tag);
	}
	
	@Override
	public TagTechnology getTag() {
		return _tag;
	}
	
	// Tag Technology Methods
	
	@Kroll.method
	public void format(NdefMessageProxy message) throws IOException, FormatException {
		if (message == null) {
			_tag.format(null);
		} else {
			_tag.format(message.getMessage());
		}
	}
	
	@Kroll.method
	public void formatReadOnly(NdefMessageProxy message) throws IOException, FormatException {
		_tag.formatReadOnly(message.getMessage());
	}
}
