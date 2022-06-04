/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc.tech;

import android.nfc.Tag;
import android.nfc.tech.MifareClassic;
import android.nfc.tech.TagTechnology;
import android.os.Build;
import android.util.Log;
import java.io.IOException;
import org.appcelerator.kroll.annotations.Kroll;
import ti.modules.titanium.BufferProxy;
import ti.nfc.NfcConstants;
import ti.nfc.NfcModule;

@Kroll.proxy(creatableInModule = NfcModule.class)
public class TagTechnologyMifareClassicProxy extends TagTechnologyProxy
{
	private MifareClassic _tag;

	public TagTechnologyMifareClassicProxy()
	{
		super();
	}

	@Override
	public void setTag(Tag tag)
	{
		_tag = MifareClassic.get(tag);
	}

	@Override
	public TagTechnology getTag()
	{
		return _tag;
	}

	// Tag Technology Methods

	@Kroll.getProperty
	public BufferProxy getKEY_DEFAULT()
	{
		return new BufferProxy(MifareClassic.KEY_DEFAULT);
	}

	@Kroll.getProperty
	public BufferProxy getKEY_MIFARE_APPLICATION_DIRECTORY()
	{
		return new BufferProxy(MifareClassic.KEY_MIFARE_APPLICATION_DIRECTORY);
	}

	@Kroll.getProperty
	public BufferProxy getKEY_NFC_FORUM()
	{
		return new BufferProxy(MifareClassic.KEY_NFC_FORUM);
	}

	@Kroll.method
	public boolean authenticateSectorWithKeyA(int sectorIndex, BufferProxy key) throws IOException
	{
		return _tag.authenticateSectorWithKeyA(sectorIndex, key.getBuffer());
	}

	@Kroll.method
	public boolean authenticateSectorWithKeyB(int sectorIndex, BufferProxy key) throws IOException
	{
		return _tag.authenticateSectorWithKeyB(sectorIndex, key.getBuffer());
	}

	@Kroll.method
	public int blockToSector(int blockIndex)
	{
		return _tag.blockToSector(blockIndex);
	}

	@Kroll.method
	public void decrement(int blockIndex, int value) throws IOException
	{
		_tag.decrement(blockIndex, value);
	}

	@Kroll.method
	public int getBlockCount()
	{
		return _tag.getBlockCount();
	}

	@Kroll.method
	public int getBlockCountInSector(int sectorIndex)
	{
		return _tag.getBlockCountInSector(sectorIndex);
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
	public int getSectorCount()
	{
		return _tag.getSectorCount();
	}

	@Kroll.method
	public int getSize()
	{
		return _tag.getSize();
	}

	@Kroll.method
	public int getTimeout()
	{
		if (Build.VERSION.SDK_INT < 14) {
			Log.w(NfcConstants.LCAT, "getTimeout is not available until API level 14");
			return 0;
		}
		return _tag.getTimeout();
	}

	@Kroll.method
	public int getType()
	{
		return _tag.getType();
	}

	@Kroll.method
	public void increment(int blockIndex, int value) throws IOException
	{
		_tag.increment(blockIndex, value);
	}

	@Kroll.method
	public BufferProxy readBlock(int blockIndex) throws IOException
	{
		byte[] result = _tag.readBlock(blockIndex);
		return new BufferProxy(result);
	}

	@Kroll.method
	public void restore(int blockIndex) throws IOException
	{
		_tag.restore(blockIndex);
	}

	@Kroll.method
	public int sectorToBlock(int sectorIndex)
	{
		return _tag.sectorToBlock(sectorIndex);
	}

	@Kroll.method
	public void setTimeout(int timeout)
	{
		if (Build.VERSION.SDK_INT < 14) {
			Log.w(NfcConstants.LCAT, "setTimeout is not available until API level 14");
			return;
		}
		_tag.setTimeout(timeout);
	}

	@Kroll.method
	public BufferProxy transceive(BufferProxy data) throws IOException
	{
		byte[] result = _tag.transceive(data.getBuffer());
		return new BufferProxy(result);
	}

	@Kroll.method
	public void transfer(int blockIndex) throws IOException
	{
		_tag.transfer(blockIndex);
	}

	@Kroll.method
	public void writeBlock(int blockIndex, BufferProxy data) throws IOException
	{
		_tag.writeBlock(blockIndex, data.getBuffer());
	}
}
