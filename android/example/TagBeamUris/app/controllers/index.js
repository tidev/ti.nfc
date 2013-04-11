/*
 * NFC Beam Example Application
 * 
 * This application demonstrates how to use the NFC module to dispatch NFC messages
 * to other NFC capable devices using the beam push Uris.
 * 
 * No additional activity/intent-filters are needed to support this functionality.
 */



var nfc = require('ti.nfc');
var nfcAdapter = null;
var useCallback = true;
var uris = null;

$.index.addEventListener('open', function(e) {
	// Must wait until the activity has been opened before setting up NFC
	setupNfc();
});

function setupNfc() {
	if (Ti.Platform.Android.API_LEVEL < 16) {
		alert("This application requires API LEVEL 16 or greater");
		return;
	}
	
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

function createDefaultUris() {
	// Copy the image from the resource directory to the external storage directory for beaming
    var srcFile = Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, 'flower.jpg');
    var tgtFile = Ti.Filesystem.getFile(Ti.Filesystem.externalStorageDirectory, 'flower.jpg');
    tgtFile.write(srcFile);
    
    // The uris can be an array of strings or Ti.Filesystem.File objects
    // This example uses a Ti.Filesystem.file object
	uris = [ tgtFile ];
}

function createPhotoUris() {
	uris = null;
	Ti.Media.openPhotoGallery({
		success:function(event) {
			// The uris can be an array of strings or Ti.Filesystem.File objects.
			// This example uses a string (the native path)
			uris = [ event.media.nativePath ];
		},
		cancel:function() {},
		error:function(error) {},
		allowEditing: false
	});
}

var typeList = [
	{ title: 'Flower Image', getUris: createDefaultUris },
	{ title: 'Photo Gallery', getUris: createPhotoUris }
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
		// Setting a beam uris callback means that the specified callback will be
		// called whenver NFC requests an array of uris to beam to another device. 
		nfcAdapter.onBeamPushUris = beamPushUrisCallback;
		nfcAdapter.setBeamPushUris(null);
	} else {
		// Setting the default uris means that the specified uris will be beamed
		// whenever NFC needs to beam a message to another device. 
		// Note that the default uris are ignored if the onBeamPushUris callback is set.
		nfcAdapter.onBeamPushUris = null;
		setDefaultUris();
	}
}

function setDefaultUris() {
	nfcAdapter.setBeamPushUris(uris);	
}

function onTypeSelected(e) {
	// Create the uris for the selected record type
	typeList[e.rowIndex].getUris();
	
	// If not using the callback mechanism then change the default NDEF push message
	if (!useCallback) {
		setDefaultUris();
	}
}

function onCallbackSelected(e) {
	useCallback = e.value;
	setupCallback();
}

function beamPushUrisCallback() {
	// This method is called when you have the 'onBeamPushUris' property set on the adapter.
	// An application can dynmically determine what uris to return based on application state.

	return uris;
}

$.index.open();
