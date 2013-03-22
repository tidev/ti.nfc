package ti.nfc.records;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Locale;

import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.util.TiConvert;

import ti.nfc.NfcConstants;
import ti.nfc.NfcModule;
import ti.nfc.api.NdefRecordApi;

import android.nfc.NdefRecord;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = {
	NfcConstants.PROPERTY_TEXT, 
	NfcConstants.PROPERTY_LANGUAGE_CODE,
	NfcConstants.PROPERTY_ENCODING
})
public class NdefRecordTextProxy extends NdefRecordProxy 
{
	public NdefRecordTextProxy() {
		super();
	}
	
	private NdefRecordTextProxy(NdefRecord record) {
		super(record);
	}

	@Override
	public NdefRecord getRecord() {
		String text = TiConvert.toString(getProperty(NfcConstants.PROPERTY_TEXT));
		String language = TiConvert.toString(getProperty(NfcConstants.PROPERTY_LANGUAGE_CODE));
		String encoding = TiConvert.toString(getProperty(NfcConstants.PROPERTY_ENCODING));
		
		if (language == null) {
			language = Locale.getDefault().getLanguage();
		}
		if (encoding == null) {
			encoding = NfcModule.ENCODING_UTF8;
		}
		
		return NdefRecordApi.getInstance().createText(text, language, encoding); 
	}
	
	public static NdefRecordTextProxy parse(NdefRecord record) {
		try {
			NdefRecordTextProxy proxy = new NdefRecordTextProxy(record);

			byte[] payload = record.getPayload();
            /*
             * payload[0] contains the "Status Byte Encodings" field, per the
             * NFC Forum "Text Record Type Definition" section 3.2.1.
             *
             * bit7 is the Text Encoding Field.
             *
             * if (Bit_7 == 0): The text is encoded in UTF-8 if (Bit_7 == 1):
             * The text is encoded in UTF16
             *
             * Bit_6 is reserved for future use and must be set to zero.
             *
             * Bits 5 to 0 are the length of the IANA language code.
             */
			String textEncoding = ((payload[0] & 0200) == 0) ? "UTF-8" : "UTF-16";
			int languageCodeLength = payload[0] & 0077;
			String languageCode = new String(payload, 1, languageCodeLength, "US-ASCII");
			String text = new String(payload, languageCodeLength + 1,
					payload.length - languageCodeLength - 1, textEncoding);
			
			proxy.setProperty(NfcConstants.PROPERTY_TEXT, text);
			proxy.setProperty(NfcConstants.PROPERTY_LANGUAGE_CODE, languageCode);
			proxy.setProperty(NfcConstants.PROPERTY_ENCODING, textEncoding);
			
			return proxy;
		} catch (UnsupportedEncodingException e) {
			throw new IllegalArgumentException(e);
		}
	}
	
	public static boolean isValid(NdefRecord record) {
		short tnf = record.getTnf();
		return ((tnf == NdefRecord.TNF_WELL_KNOWN) &&
				(Arrays.equals(record.getType(), NdefRecord.RTD_TEXT)));
	}
}
