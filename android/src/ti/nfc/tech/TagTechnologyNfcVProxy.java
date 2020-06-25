/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.tech;

import android.nfc.Tag;
import android.nfc.tech.NfcV;
import android.nfc.tech.TagTechnology;
import android.os.Build;
import android.util.Log;
import java.io.IOException;
import org.appcelerator.kroll.annotations.Kroll;
import ti.modules.titanium.BufferProxy;
import ti.nfc.NfcConstants;
import ti.nfc.NfcModule;

@Kroll.proxy(creatableInModule = NfcModule.class)
public class TagTechnologyNfcVProxy extends TagTechnologyProxy
{
	private NfcV _tag;

	public TagTechnologyNfcVProxy()
	{
		super();
	}

	@Override
	public void setTag(Tag tag)
	{
		_tag = NfcV.get(tag);
	}

	@Override
	public TagTechnology getTag()
	{
		return _tag;
	}

	// Tag Technology Methods

	@Kroll.method
	public byte getDsfId()
	{
		return _tag.getDsfId();
	}

	@Kroll.method
	public int getMaxTransceiveLength()
	{
		if (Build.VERSION.SDK_INT < 14) {
			Log.w(NfcConstants.LCAT, "getMaxTransceiveLength is not available until API level 14");
			return 0;
		}
		return _tag.getMaxTransceiveLength();
	}

	@Kroll.method
	public byte getResponseFlags()
	{
		return _tag.getResponseFlags();
	}

	@Kroll.method
	public BufferProxy transceive(BufferProxy data) throws IOException
	{
		byte[] result = _tag.transceive(data.getBuffer());
		return new BufferProxy(result);
	}
}
