/* 
 * NFC Tag Viewer Example Application
 * 
 * This application demonstrates how to use the NFC module to enable
 * NFC message dispatching, even when the application is not running.
 *
 * The setup for this module uses intent-filters in the tiapp.xml file to specify which
 * types of NFC messages the application wants to receive. By using intent-filters in
 * the tiapp.xml file, the application will be automatically started if a matching
 * NFC message is dispatched. 
 * 
 * Before running this application, add code similar to the following to your application's
 * tiapp.xml file. Note the following:
 *   - The activity name for your application may be different
 *   - android:launchMode="singleTask" is needed so that new intents that result from
 *     NFC message dispatching do not start a new activity in your application
 *   - The NFC specific intent filters can be modified to your application needs.
 * 
 *  <android xmlns:android="http://schemas.android.com/apk/res/android">
 *    <manifest>
 *      <application>
 *        <activity android:name=".TagviewerActivity"
 *            android:label="TagViewer" android:theme="@style/Theme.Titanium"
 *            android:configChanges="keyboardHidden|orientation"
 *            android:launchMode="singleTask"
 *            android:exported="true">
 *          <intent-filter>
 *            <action android:name="android.intent.action.MAIN" />
 *            <category android:name="android.intent.category.LAUNCHER" />
 *          </intent-filter>
 *          <intent-filter>
 *            <action android:name="android.nfc.action.NDEF_DISCOVERED"/>
 *            <category android:name="android.intent.category.DEFAULT"/>
 *            <data android:mimeType="text/plain"/>
 *          </intent-filter>
 *          <intent-filter>
 *            <action android:name="android.nfc.action.NDEF_DISCOVERED"/>
 *            <category android:name="android.intent.category.DEFAULT"/>
 *            <data android:scheme="http"/>
 *          </intent-filter>
 *        </activity>
 *      </application>
 *    </manifest>
 *  </android>
 */

var nfc = require('ti.nfc');
var nfcAdapter = null;

$.index.addEventListener('open', function(e) {
	// Must wait until the activity has been opened before setting up NFC
	setupNfc();
});

// Force the instructions into the data area
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
}

function handleDiscovery(e) {
	// Add rows for the message, tag, and each of the records
	var data = [];
	data.push(Alloy.createController('rowMessage', { action: e.action }).getView());
	data.push(Alloy.createController('rowTag', { tag: e.tag }).getView());
	if (e.messages) {
		var message = e.messages[0];
		if (message.records) {
			var i, len;
			for (i=0, len=message.records.length; i<len; i++) {
				data.push(Alloy.createController('rowRecord', { record: message.records[i] }).getView());
			}
		}
	}
	$.instructions.zIndex = -10000;
	$.records.setData(data);
};

function onClear(e) {
	$.records.setData([]);
	$.instructions.zIndex = 10000;
}


