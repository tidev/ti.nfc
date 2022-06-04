/*
 * NFC Foreground Dispatch Example Application
 * 
 * This application demonstrates how to use the NFC module to enable
 * NFC message dispatching only when the application is in the foreground.
 * 
 * Before running this application, add code similar to the following to your application's
 * tiapp.xml file. Note the following:
 *   - The activity name for your application may be different
 *   - android:launchMode="singleTask" is needed so that new intents that result from
 *     NFC message dispatching do not start a new activity in your application
 * 
 *  <android xmlns:android="http://schemas.android.com/apk/res/android">
 *    <manifest>
 *      <application>
 *        <activity android:name=".TagForegroundActivity"
 *            android:label="TagForeground" android:theme="@style/Theme.Titanium"
 *            android:configChanges="keyboardHidden|orientation"
 *            android:launchMode="singleTask"
 *            android:exported="true">
 *          <intent-filter>
 *            <action android:name="android.intent.action.MAIN" />
 *            <category android:name="android.intent.category.LAUNCHER" />
 *          </intent-filter>
 *        </activity>
 *      </application>
 *    </manifest>
 *  </android>
 */

var nfc = require('ti.nfc');
var nfcAdapter = null;
var dispatchFilter = null;

$.index.addEventListener('open', function(e) {
	// Must wait until the activity has been opened before setting up NFC
	setupNfc();
});

// Force the default message into the data area
onClear({});

$.index.open();

function setupNfc() {
	// Create the NFC adapter to be associated with this activity. 
	// There should only be ONE adapter created per activity.
	nfcAdapter = nfc.createNfcAdapter({
		onNdefDiscovered: handleDiscovery,
		onTagDiscovered: handleDiscovery,
		onTechDiscovered: handleDiscovery
	});
	
	// It's possible that the device does not support NFC. Check it here
	// before we go any further.
	if (!nfcAdapter.isEnabled()) {
		alert('NFC is not enabled on this device');
		return;
	}
	
	// All tag scans are received by the activity as a new intent. Each
	// scan intent needs to be passed to the nfc adapter for processing.
	var act = Ti.Android.currentActivity;
	act.addEventListener('newintent', function(e) {
		nfcAdapter.onNewIntent(e.intent);
	});
	
	// To enable NFC dispatching only while the application is in the foreground,
	// the application must signal the module whenever the application state changes.
	act.addEventListener('resume', function(e) {
		nfcAdapter.enableForegroundDispatch(dispatchFilter);
	});
	act.addEventListener('pause', function(e) {
		nfcAdapter.disableForegroundDispatch();
	});
	
	// This application is only interested in receiving NFC messages while
	// in the foreground. So the dispatch filter must be defined to identify
	// what types of NFC messages to receive.
	dispatchFilter = nfc.createNfcForegroundDispatchFilter({
		intentFilters: [
			// The discovery could be restricted to only text with
			// { action: nfc.ACTION_NDEF_DISCOVERED, mimeType: 'text/plain' },
			{ action: nfc.ACTION_NDEF_DISCOVERED, mimeType: '*/*' },
			// The discovery could be restricted by host with
			//{ action: nfc.ACTION_NDEF_DISCOVERED, scheme: 'http', host: 'www.appcelerator.com' }
			{ action: nfc.ACTION_NDEF_DISCOVERED, scheme: 'http' }
		],
		// The techList can be specified to filter TECH_DISCOVERED messages by technology
		techLists: [
			[ "android.nfc.tech.NfcF" ],
			[ "android.nfc.tech.Ndef" ],
			[ "android.nfc.tech.MifareClassic" ],
			[ "android.nfc.tech.NfcA" ]
		]
	});
	
	// Set the default Ndef message to send when tapped
	// Only works if onPushMessage is null
	var textRecord = nfc.createNdefRecordText({
		text: "NDEF Push Sample"
	});
	var msg = nfc.createNdefMessage({
		records: [ textRecord ]
	});
	nfcAdapter.setNdefPushMessage(msg);
}

function handleDiscovery(e) {
	// A recognized NCF message was discovered and routed to this application.
	// Just display the contents of the messages in the scroll view.
	$.tagData.value = JSON.stringify(e, function(key, value) {
    	if(key === 'source') {
        	return undefined;
    	} else {
        	return value;
    	}
	}, 2);
}

function onClear(e) {
	$.tagData.value = "This application will only push or receive NFC data when it is in the foreground.\n\nTap another Android phone with NFC to push 'NDEF Push Sample'.\n\nThis application will also receive 'http' and mimeType pushes.";
}


