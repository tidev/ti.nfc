/* 
 * NFC Tag Viewer Example Application
 * 
 * This application demonstrates how to use the iOS 11+ NFC module.
 */

var nfc = require('ti.nfc');
var nfcAdapter = nfc.createNfcAdapter({
	onNdefDiscovered: handleDiscovery
});

function handleDiscovery(e) {
	// Add rows for the message, tag, and each of the records
	var data = [];

	if (e.messages) {
		var message = e.messages[0];
		if (message.records) {
			for (var i = 0; i < message.records.length; i++) {
				data.push(message.records[i]);
			}
		}
	}
	
	Ti.API.info(data);
}

var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
    title: 'Start Search'
});

btn.addEventListener('click', function() {
    nfcAdapter.begin();
});

win.add(btn);
win.open();
