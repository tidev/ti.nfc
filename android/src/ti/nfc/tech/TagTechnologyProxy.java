/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.tech;

import android.nfc.Tag;
import android.nfc.tech.TagTechnology;
import java.io.IOException;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import ti.nfc.NfcConstants;
import ti.nfc.NfcTagProxy;

@Kroll.proxy(propertyAccessors = { NfcConstants.PROPERTY_TAG })
public abstract class TagTechnologyProxy extends KrollProxy
{
	public TagTechnologyProxy()
	{
		super();
	}

	protected abstract void setTag(Tag tag);
	protected abstract TagTechnology getTag();

	@Override
	public void handleCreationDict(KrollDict kd)
	{
		if (kd.containsKey(NfcConstants.PROPERTY_TAG)) {
			Object tag = kd.get(NfcConstants.PROPERTY_TAG);
			if (tag instanceof NfcTagProxy) {
				NfcTagProxy nfcTag = (NfcTagProxy) tag;
				setTag(nfcTag.getTag());
			}
		}

		super.handleCreationDict(kd);
	}

	@Override
	public void onPropertyChanged(String name, Object value)
	{
		if (name.equals(NfcConstants.PROPERTY_TAG)) {
			if (value instanceof NfcTagProxy) {
				NfcTagProxy nfcTag = (NfcTagProxy) value;
				setTag(nfcTag.getTag());
			}
		}

		super.onPropertyChanged(name, value);
	}

	private TagTechnology getTagInstance() throws IllegalStateException
	{
		TagTechnology tag = getTag();
		if (tag == null) {
			throw new IllegalStateException("No tag created for specified technology.");
		}
		return tag;
	}

	@Kroll.method
	public boolean isValid()
	{
		return (getTag() != null);
	}

	@Kroll.method
	public void close() throws IOException
	{
		TagTechnology tag = getTagInstance();
		tag.close();
	}

	@Kroll.method
	public void connect() throws IOException
	{
		TagTechnology tag = getTagInstance();
		tag.connect();
	}

	@Kroll.method
	public boolean isConnected()
	{
		TagTechnology tag = getTagInstance();
		return tag.isConnected();
	}
}