package ti.nfc.records;

import org.appcelerator.kroll.annotations.Kroll;

import android.nfc.NdefRecord;

@Kroll.proxy
public class NdefRecordUnknownProxy extends NdefRecordProxy 
{
	private NdefRecord _record;
	
	public NdefRecordUnknownProxy() {
		super();
	}
	
	private NdefRecordUnknownProxy(NdefRecord record) {
		super(record);
		_record = record;
	}

	@Override
	public NdefRecord getRecord() {
		return _record;
	}
	
	public static NdefRecordUnknownProxy parse(NdefRecord record) {
		NdefRecordUnknownProxy proxy = new NdefRecordUnknownProxy(record);
		
		return proxy;
	}
	
	public static boolean isValid(NdefRecord record) {
		// This is a "catch-all" record type -- all records are supported
		return true;
	}
}
