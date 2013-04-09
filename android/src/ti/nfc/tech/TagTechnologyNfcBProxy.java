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

import ti.modules.titanium.BufferProxy;
import ti.nfc.NfcConstants;
import ti.nfc.NfcModule;

import android.nfc.Tag;
import android.nfc.tech.NfcB;
import android.nfc.tech.TagTechnology;
import android.os.Build;
import android.util.Log;

@Kroll.proxy(creatableInModule = NfcModule.class)
public class TagTechnologyNfcBProxy extends TagTechnologyProxy 
{
	private NfcB _tag;
	
	public TagTechnologyNfcBProxy() {
		super();
	}
	
	@Override
	public  void setTag(Tag tag) {
		_tag = NfcB.get(tag);
	}
	
	@Override
	public TagTechnology getTag() {
		return _tag;
	}
	
	// Tag Technology Methods
	
	@Kroll.method
	public BufferProxy getApplicationData() {
		byte[] data = _tag.getApplicationData();
		return new BufferProxy(data);
	}
	
	@Kroll.method
	public int getMaxTransceiveLength() {
    	if (Build.VERSION.SDK_INT < 14) {
    		Log.w(NfcConstants.LCAT, "getMaxTransceiveLength is not available until API level 14");
    		return 0;
    	}	
		return _tag.getMaxTransceiveLength();
	}
	
	@Kroll.method
	public BufferProxy getProtocolInfo() {
		byte[] data = _tag.getProtocolInfo();
		return new BufferProxy(data);
	}
	
	@Kroll.method
	public BufferProxy transceive(BufferProxy data) throws IOException {
		byte[] result = _tag.transceive(data.getBuffer());
		return new BufferProxy(result);
	}
}
