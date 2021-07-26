/*
 * NFC Tag Writer Example Application
 * 
 * This application demonstrates how to use the NFC module to write to NFC tags.
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
 *        <activity android:name=".TagwriterActivity"
 *            android:label="TagWriter" android:theme="@style/Theme.Titanium"
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
var scannedTag = null;

$.index.addEventListener('open', function(e) {
	// Must wait until the activity has been opened before setting up NFC
	setupNfc();
});

// Force the default message into the data area
onClear();

$.index.open();

function setupNfc() {
	// Create the NFC adapter to be associated with this activity. 
	// There should only be ONE adapter created per activity.
	nfcAdapter = nfc.createNfcAdapter({
		onTagDiscovered: handleDiscovery
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
			{ action: nfc.ACTION_TAG_DISCOVERED}
		]
	});
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
	
	// Save off the scanned tag
	scannedTag = e.tag;
	
	// Determine if tag supports the format we are looking for in order to write
	$.writeButton.enabled = scannedTag.techList.indexOf(nfc.TECH_NDEF) >= 0;
}

function onWrite(e) {
	var tech = nfc.createTagTechnologyNdef({
		tag: scannedTag
	});
	
	// We checked when the tag was scanned that it supported the necessary tag type (Ndef in this case).
	if (!tech.isValid()) {
		alert("Failed to create Ndef tag type");
		return;
	} 

	// Attempt to write an Ndef record to the tag
	try {
		tech.connect();
		
		// It's possible that the tag is not writable, so we need to check first.
		if (!tech.isWritable()) {
			alert ("Tag is not writable");
		} else {
			// Create a new message to write to the tag
			var date = new Date();
			var textRecord = nfc.createNdefRecordText({
				text: "Titanium NFC module. Tag updated on " + date.toLocaleString() + "!!!"
			});
			var msg = nfc.createNdefMessage({
				records: [ textRecord ]
			});
	
			// For good measure, confirm that the message is not too big for the tag
			var blob = msg.toByte();
			if (blob.length > tech.getMaxSize()) {
				alert("Tag capacity is " + tech.getMaxSize() + ", but message size is " + blob.length);
			} else {
				// Write to the tag
				tech.writeNdefMessage(msg);
				alert("Tag successfully updated!");
				onClear();
			}
		}
	} catch (e) {
		alert("Error: " + e.message);
		$.writeButton.enabled = false;
	} finally {
		if (tech.isConnected()) {
			tech.close();
		}
	}
}

function onClear(e) {
	$.tagData.value = "This application will only receive or write NFC data when it is in the foreground.\n\nThis application will write to discovered tags that support the Ndef format.\n\nScan a tag and tap on 'Write' to write to the tag.";
}



