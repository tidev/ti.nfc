package ti.nfc.records;

import org.appcelerator.kroll.annotations.Kroll;

import ti.nfc.NfcModule;
import android.nfc.NdefRecord;

@Kroll.proxy(creatableInModule = NfcModule.class)
public class NdefRecordEmptyProxy extends NdefRecordProxy 
{
	public NdefRecordEmptyProxy() {
		super();
	}
	
	private NdefRecordEmptyProxy(NdefRecord record) {
		super(record);
	}
	
	@Override
	public NdefRecord getRecord() {
		byte[] empty = new byte[] {};
		
		return new NdefRecord(NdefRecord.TNF_EMPTY, empty, empty, empty);	
	}
	
	public static NdefRecordEmptyProxy parse(NdefRecord record) {
		NdefRecordEmptyProxy proxy = new NdefRecordEmptyProxy(record);
		
		return proxy;
	}

	public static boolean isValid(NdefRecord record) {
		short tnf = record.getTnf();
		return (tnf == NdefRecord.TNF_EMPTY);
	}
}
