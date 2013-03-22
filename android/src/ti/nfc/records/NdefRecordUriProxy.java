package ti.nfc.records;

import java.nio.charset.Charset;
import java.util.Arrays;

import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.util.TiConvert;

import android.net.Uri;
import android.nfc.NdefRecord;

import ti.nfc.NfcConstants;
import ti.nfc.NfcModule;
import ti.nfc.api.NdefRecordApi;
import ti.nfc.api.NdefRecordSupport;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = {
	NfcConstants.PROPERTY_URI
})
public class NdefRecordUriProxy extends NdefRecordProxy 
{
	public NdefRecordUriProxy() {
		super();
	}
	
	private NdefRecordUriProxy(NdefRecord record) {
		super(record);
	}
	
	@Override
	public NdefRecord getRecord() {
		String uri = TiConvert.toString(getProperty(NfcConstants.PROPERTY_URI));
		
		return NdefRecordApi.getInstance().createUri(uri);
	}
	
	public static NdefRecordUriProxy parse(NdefRecord record) {
		NdefRecordUriProxy proxy = new NdefRecordUriProxy(record);

		short tnf = record.getTnf();
		byte[] payload = record.getPayload();
        /*
         * payload[0] contains the URI Identifier Code, per the
         * NFC Forum "URI Record Type Definition" section 3.2.2.
         *
         * payload[1]...payload[payload.length - 1] contains the rest of
         * the URI.
         */
		Uri uri;
		if (tnf == NdefRecord.TNF_ABSOLUTE_URI) {
			uri = Uri.parse(new String(payload, Charset.forName("UTF-8")));
		} else if (tnf == NdefRecord.TNF_WELL_KNOWN){
			short index = payload[0];
			String prefix = "";
			if ((index >= 0) && (index < NdefRecordSupport.URI_PREFIX_MAP.length)) {
				prefix = NdefRecordSupport.URI_PREFIX_MAP[index];
			}
			byte[] prefixBytes = prefix.getBytes(Charset.forName("UTF-8"));
			
			byte[] fullUri = new byte[prefixBytes.length + payload.length - 1];
			System.arraycopy(prefixBytes, 0, fullUri, 0, prefixBytes.length);
			System.arraycopy(payload, 1, fullUri, prefixBytes.length, payload.length - 1);
			uri = Uri.parse(new String(fullUri, Charset.forName("UTF-8")));
		} else {
			return null;
		}
		
		proxy.setProperty(NfcConstants.PROPERTY_URI, uri.toString());
		
		return proxy;
	}
	
	public static boolean isValid(NdefRecord record) {
		short tnf = record.getTnf();
		return ((tnf == NdefRecord.TNF_ABSOLUTE_URI)  ||
				((tnf == NdefRecord.TNF_WELL_KNOWN) &&
				 (Arrays.equals(record.getType(), NdefRecord.RTD_URI))));
	}
}
