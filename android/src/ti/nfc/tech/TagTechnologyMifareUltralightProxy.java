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
import android.nfc.tech.MifareUltralight;
import android.nfc.tech.TagTechnology;
import android.os.Build;
import android.util.Log;

@Kroll.proxy(creatableInModule = NfcModule.class)
public class TagTechnologyMifareUltralightProxy extends TagTechnologyProxy 
{
	private MifareUltralight _tag;
	
	public TagTechnologyMifareUltralightProxy() {
		super();
	}
	
	@Override
	public  void setTag(Tag tag) {
		_tag = MifareUltralight.get(tag);
	}
	
	@Override
	public TagTechnology getTag() {
		return _tag;
	}
	
	// Tag Technology Methods
	
	@Kroll.method
	public int getMaxTransceiveLength() {
    	if (Build.VERSION.SDK_INT < 14) {
    		Log.w(NfcConstants.LCAT, "getMaxTransceiveLength is not available until API level 14");
    		return 0;
    	}	
		return _tag.getMaxTransceiveLength();
	}
	
	@Kroll.method
	public int getTimeout() {
    	if (Build.VERSION.SDK_INT < 14) {
    		Log.w(NfcConstants.LCAT, "getTimeout is not available until API level 14");
    		return 0;
    	}	
		return _tag.getTimeout();
	}
	
	@Kroll.method
	public int getType() {
		return _tag.getType();
	}
	
	@Kroll.method
	public BufferProxy readPages(int pageOffset) throws IOException {
		byte[] result = _tag.readPages(pageOffset);
		return new BufferProxy(result);
	}
	
	@Kroll.method
	public void setTimeout(int timeout) {
    	if (Build.VERSION.SDK_INT < 14) {
    		Log.w(NfcConstants.LCAT, "setTimeout is not available until API level 14");
    		return;
    	}	
		_tag.setTimeout(timeout);
	}
	
	@Kroll.method
	public BufferProxy transceive(BufferProxy data) throws IOException {
		byte[] result = _tag.transceive(data.getBuffer());
		return new BufferProxy(result);
	}
	
	@Kroll.method
	public void writePage(int pageOffset, BufferProxy data) throws IOException {
		_tag.writePage(pageOffset, data.getBuffer());
	}
}
