/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc;

import android.nfc.NdefRecord;
import android.nfc.NfcAdapter;
import android.nfc.tech.MifareClassic;
import android.nfc.tech.MifareUltralight;
import android.nfc.tech.Ndef;
import android.util.Log;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;

@Kroll.module(name = "Nfc", id = "ti.nfc")
public class NfcModule extends KrollModule
{
	@Kroll.constant
	public static final short TNF_ABSOLUTE_URI = NdefRecord.TNF_ABSOLUTE_URI;
	@Kroll.constant
	public static final short TNF_EMPTY = NdefRecord.TNF_EMPTY;
	@Kroll.constant
	public static final short TNF_EXTERNAL_TYPE = NdefRecord.TNF_EXTERNAL_TYPE;
	@Kroll.constant
	public static final short TNF_MIME_MEDIA = NdefRecord.TNF_MIME_MEDIA;
	@Kroll.constant
	public static final short TNF_UNCHANGED = NdefRecord.TNF_UNCHANGED;
	@Kroll.constant
	public static final short TNF_UNKNOWN = NdefRecord.TNF_UNKNOWN;
	@Kroll.constant
	public static final short TNF_WELL_KNOWN = NdefRecord.TNF_WELL_KNOWN;

	@Kroll.constant
	public static final String ENCODING_UTF8 = "UTF-8";
	@Kroll.constant
	public static final String ENCODING_UTF16 = "UTF-16";

	@Kroll.constant
	public static final String RTD_ALTERNATIVE_CARRIER = "ac";
	@Kroll.constant
	public static final String RTD_HANDOVER_CARRIER = "Hc";
	@Kroll.constant
	public static final String RTD_HANDOVER_REQUEST = "Hr";
	@Kroll.constant
	public static final String RTD_HANDOVER_SELECT = "Hs";
	@Kroll.constant
	public static final String RTD_SMART_POSTER = "Sp";
	@Kroll.constant
	public static final String RTD_TEXT = "T";
	@Kroll.constant
	public static final String RTD_URI = "U";

	@Kroll.constant
	public static final String ACTION_NDEF_DISCOVERED = NfcAdapter.ACTION_NDEF_DISCOVERED;
	@Kroll.constant
	public static final String ACTION_TAG_DISCOVERED = NfcAdapter.ACTION_TAG_DISCOVERED;
	@Kroll.constant
	public static final String ACTION_TECH_DISCOVERED = NfcAdapter.ACTION_TECH_DISCOVERED;

	@Kroll.constant
	public static final short RECOMMENDED_ACTION_UNKNOWN = -1;
	@Kroll.constant
	public static final short RECOMMENDED_ACTION_DO_ACTION = 0;
	@Kroll.constant
	public static final short RECOMMENDED_ACTION_SAVE_FOR_LATER = 1;
	@Kroll.constant
	public static final short RECOMMENDED_ACTION_OPEN_FOR_EDITING = 2;

	@Kroll.constant
	public static final String TECH_ISODEP = "android.nfc.tech.IsoDep"; // IsoDep.class.getName();
	@Kroll.constant
	public static final String TECH_MIFARE_CLASSIC = "android.nfc.tech.MifareClassic"; // MifareClassic.class.getName();
	@Kroll.constant
	public static final String TECH_MIFARE_ULTRALIGHT =
		"android.nfc.tech.MifareUltralight"; // MifareUltralight.class.getName();
	@Kroll.constant
	public static final String TECH_NDEF = "android.nfc.tech.Ndef"; // Ndef.class.getName();
	@Kroll.constant
	public static final String TECH_NDEFFORMATABLE =
		"android.nfc.tech.NdefFormatable"; // NdefFormatable.class.getName();
	@Kroll.constant
	public static final String TECH_NDEF_FORMATABLE =
		"android.nfc.tech.NdefFormatable"; // NdefFormatable.class.getName();
	@Kroll.constant
	public static final String TECH_NFCA = "android.nfc.tech.NfcA"; // NfcA.class.getName();
	@Kroll.constant
	public static final String TECH_NFCB = "android.nfc.tech.NfcB"; // NfcB.class.getName();
	@Kroll.constant
	public static final String TECH_NFCF = "android.nfc.tech.NfcF"; // NfcF.class.getName();
	@Kroll.constant
	public static final String TECH_NFCV = "android.nfc.tech.NfcV"; // NfcV.class.getName();

	@Kroll.constant
	public static final String TAG_TYPE_NFC_FORUM_TYPE_1 = android.nfc.tech.Ndef.NFC_FORUM_TYPE_1;
	@Kroll.constant
	public static final String TAG_TYPE_NFC_FORUM_TYPE_2 = android.nfc.tech.Ndef.NFC_FORUM_TYPE_2;
	@Kroll.constant
	public static final String TAG_TYPE_NFC_FORUM_TYPE_3 = android.nfc.tech.Ndef.NFC_FORUM_TYPE_3;
	@Kroll.constant
	public static final String TAG_TYPE_NFC_FORUM_TYPE_4 = android.nfc.tech.Ndef.NFC_FORUM_TYPE_4;
	@Kroll.constant
	public static final String TAG_TYPE_MIFARE_CLASSIC = android.nfc.tech.Ndef.MIFARE_CLASSIC;

	@Kroll.constant
	public static final int MIFARE_TAG_TYPE_CLASSIC = MifareClassic.TYPE_CLASSIC;
	@Kroll.constant
	public static final int MIFARE_TAG_TYPE_PLUS = MifareClassic.TYPE_PLUS;
	@Kroll.constant
	public static final int MIFARE_TAG_TYPE_PRO = MifareClassic.TYPE_PRO;
	@Kroll.constant
	public static final int MIFARE_TAG_TYPE_UNKNOWN = MifareClassic.TYPE_UNKNOWN;
	@Kroll.constant
	public static final int MIFARE_BLOCK_SIZE = MifareClassic.BLOCK_SIZE;
	@Kroll.constant
	public static final int MIFARE_SIZE_1K = MifareClassic.SIZE_1K;
	@Kroll.constant
	public static final int MIFARE_SIZE_2K = MifareClassic.SIZE_2K;
	@Kroll.constant
	public static final int MIFARE_SIZE_4K = MifareClassic.SIZE_4K;
	@Kroll.constant
	public static final int MIFARE_SIZE_MINI = MifareClassic.SIZE_MINI;

	@Kroll.constant
	public static final int MIFARE_ULTRALIGHT_PAGE_SIZE = MifareUltralight.PAGE_SIZE;
	@Kroll.constant
	public static final int MIFARE_ULTRALIGHT_TYPE_ULTRALIGHT = MifareUltralight.TYPE_ULTRALIGHT;
	@Kroll.constant
	public static final int MIFARE_ULTRALIGHT_TYPE_ULTRALIGHT_C = MifareUltralight.TYPE_ULTRALIGHT_C;
	@Kroll.constant
	public static final int MIFARE_ULTRALIGHT_TYPE_UNKNOWN = MifareUltralight.TYPE_UNKNOWN;

	public NfcModule()
	{
		super();
		Log.d(NfcConstants.LCAT, "NfcModule Loaded");
	}
}
