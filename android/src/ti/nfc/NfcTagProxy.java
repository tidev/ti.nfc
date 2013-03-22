package ti.nfc;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;

import android.nfc.Tag;

@Kroll.proxy
public class NfcTagProxy extends KrollProxy 
{
	private String _id;
	private String[] _techList;
	
	public NfcTagProxy() {
		super();
	}
	
	public NfcTagProxy(Tag tag) {
		this();

		byte[] id = tag.getId();
		if (id != null) {
			_id = bytesToString(id).toString();
		}		
		
		_techList = tag.getTechList();
	}
	
	@Kroll.getProperty @Kroll.method
	public String getId() {
		return _id;
	}
	
	@Kroll.getProperty @Kroll.method
	public String[] getTechList() {
		return _techList;
	}
	
    private static StringBuilder bytesToString(byte[] bs) {
        StringBuilder s = new StringBuilder();
        for (byte b : bs) {
            s.append(String.format("%02X", b));
        }
        return s;
    }
}