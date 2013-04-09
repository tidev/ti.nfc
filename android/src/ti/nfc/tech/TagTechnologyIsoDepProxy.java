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
import android.nfc.tech.IsoDep;
import android.nfc.tech.TagTechnology;
import android.os.Build;
import android.util.Log;

@Kroll.proxy(creatableInModule = NfcModule.class)
public class TagTechnologyIsoDepProxy extends TagTechnologyProxy 
{
	private IsoDep _tag;
	
	public TagTechnologyIsoDepProxy() {
		super();
	}
	
	@Override
	public  void setTag(Tag tag) {
		_tag = IsoDep.get(tag);
	}
	
	@Override
	public TagTechnology getTag() {
		return _tag;
	}
	
	// Tag Technology Methods
	
	@Kroll.method
	public BufferProxy getHiLayerResponse() {
		byte[] result = _tag.getHiLayerResponse();
		if (result == null) {
			return null;
		}
		return new BufferProxy(result);
	}
	
	@Kroll.method
	public BufferProxy getHistoricalBytes() {
		byte[] result = _tag.getHistoricalBytes();
		if (result == null) {
			return null;
		}
		return new BufferProxy(result);
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
	public int getTimeout() {
    	if (Build.VERSION.SDK_INT < 14) {
    		Log.w(NfcConstants.LCAT, "getTimeout is not available until API level 14");
    		return 0;
    	}	
    	return _tag.getTimeout();
	}
	
	@Kroll.method
	public boolean isExtendedLengthApduSupported() {
    	if (Build.VERSION.SDK_INT < 16) {
    		Log.w(NfcConstants.LCAT, "isExtendedLengthApduSupported is not available until API level 16");
    		return false;
    	}			
    	return _tag.isExtendedLengthApduSupported();
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
}
