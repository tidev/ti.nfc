/*
 * NFC Beam Example Application
 * 
 * This application demonstrates how to use the NFC module to dispatch NFC messages
 * to other NFC capable devices.
 * 
 * No additional activity/intent-filters are needed to support this functionality.
 */

var nfc = require('ti.nfc');
var nfcAdapter = null;
var useCallback = true;
var ndefRecord = null;

$.index.addEventListener('open', function(e) {
	// Must wait until the activity has been opened before setting up NFC
	setupNfc();
});

function setupNfc() {
	// Create the NFC adapter to be associated with this activity. 
	// There should only be ONE adapter created per activity.
	nfcAdapter = nfc.createNfcAdapter({
		onPushComplete: handlePushComplete
	});
	
	// It's possible that the device does not support NFC. Check it here
	// before we go any further.
	if (!nfcAdapter.isEnabled()) {
		alert('NFC is not enabled on this device');
		return;
	}
	
	// Set up the callback mechanism for this application
	setupCallback();
}

function handlePushComplete(e) {
	Ti.API.info('<<< Message Sent! >>>');
}

function createUriRecord() {
	return nfc.createNdefRecordUri({
		uri: "http://www.appcelerator.com"
	});
}

function createTextRecord() {
	return nfc.createNdefRecordText({
		text: "Hello from the beam application"
	});
}

function createMediaRecord() {
	var file = Titanium.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory, 'default.png');
	var image = file.read();
	return nfc.createNdefRecordMedia({
		payload: image
	});
}

function createApplicationRecord() {
	return nfc.createNdefRecordApplication({
		packageName: 'com.appcelerator.tagviewer'
	});
}

function createEmptyRecord() {
	return nfc.createNdefRecordEmpty({});
}

function createExternalRecord() {
	return nfc.createNdefRecordExternal({
		domain: 'com.appcelerator.tagbeam',
		domainType: 'externalType'
	})
}

function createSmartPosterRecord() {
	return nfc.createNdefRecordSmartPoster({
		title: 'Appcelerator',
		uri: 'http://www.appcelerator.com',
		action: nfc.RECOMMENDED_ACTION_DO_ACTION
	})
}

var typeList = [
	{ title: 'Text', record: createTextRecord },
	{ title: 'Uri', record: createUriRecord },
	{ title: 'Media', record: createMediaRecord },
	{ title: 'Application', record: createApplicationRecord },
	{ title: 'Empty', record: createEmptyRecord },
	{ title: 'External', record: createExternalRecord },
	{ title: 'SmartPoster', record: createSmartPosterRecord }	
];

var data = [];
typeList.map(function(t) {
	data.push(Ti.UI.createPickerRow({
		title: t.title
	}));
});

$.typeSpinner.add(data);
$.typeSpinner.setSelectedRow(0,0,true);

function setupCallback() {
	if (useCallback) {
		// Setting a push message callback means that the specified callback will be
		// called whenver NFC requests a message for beaming to another device. 
		nfcAdapter.onPushMessage = pushMessageCallback;
		nfcAdapter.setNdefPushMessage(null);
	} else {
		// Setting the default message means that the specified message will be sent
		// whenever NFC needs to beam a message to another device. 
		// Note that the default message is ignored if the onPushMessage callback is set.
		nfcAdapter.onPushMessage = null;
		setDefaultMessage();
	}
}

function setDefaultMessage() {
	var message = nfc.createNdefMessage({
		records: [ ndefRecord ]
	});

	// Set the default NDEF push message
	nfcAdapter.setNdefPushMessage(message);	
}

function onTypeSelected(e) {
	// Create the NDEF record for the selected record type
	ndefRecord = typeList[e.rowIndex].record();
	
	// If not using the callback mechanism then change the default NDEF push message
	if (!useCallback) {
		setDefaultMessage();
	}
}

function onCallbackSelected(e) {
	useCallback = e.value;
	setupCallback();
}

function pushMessageCallback() {
	// This method is called when you have the 'onPushMessage' property set on the adapter.
	// An application can dynmically determine what message to return based on application state.
	var message = nfc.createNdefMessage({
		records: [
			ndefRecord 
			/**
		      * The Android Application Record (AAR) is commented out. When a device
		      * receives a push with an AAR in it, the application specified in the AAR
		      * is guaranteed to run. The AAR overrides the tag dispatch system.
		      * You can add it back in to guarantee that the specified
		      * activity starts when receiving a beamed message. For now, this code
		      * uses the tag dispatch system.
		      */
    		//, nfc.createNdefRecordApplication({ packageName: "com.appcelerator.tagviewer" })
		]
	});

	return message;
}

$.index.open();
