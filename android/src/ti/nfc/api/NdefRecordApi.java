package ti.nfc.api;

import android.net.Uri;
import android.nfc.NdefRecord;
import android.os.Build;

public abstract class NdefRecordApi 
{
	private static NdefRecordApi _recordApi = null;
	
	public static NdefRecordApi getInstance() {
		if (_recordApi == null) {
			if (Build.VERSION.SDK_INT >= 16) {
				_recordApi = new NdefRecordApi16();
			} else if (Build.VERSION.SDK_INT >= 14) {
				_recordApi = new NdefRecordApi14();
			} else if (Build.VERSION.SDK_INT >= 10) {
				_recordApi = new NdefRecordApi10();
			} else {
				throw new UnsupportedOperationException("Nfc is not supported on this device");
			}
		}
			
		return _recordApi;
	}
	
	public NdefRecord createText(String text, String language, String encoding) {
		return NdefRecordSupport.createText(text, language, encoding);
	}
	
    public NdefRecord createUri(String uriString) {
    	return createUri(Uri.parse(uriString));
    }
    
    public abstract NdefRecord createApplication(String packageName);
    public abstract NdefRecord createUri(Uri uri);
    public abstract NdefRecord createMime(String mimeType, byte[] mimeData);
    public abstract NdefRecord createExternal(String domain, String type, byte[] data);
}
