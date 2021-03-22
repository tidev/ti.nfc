/*
* NFC Tag Viewer Example Application
*
* This application demonstrates how to use the iOS 11+ NFC module.
*
* Ensure to include the required entitlements to the <ios> section of your tiapp.xml:
*
*   <entitlements>
*     <dict>
*       <key>com.apple.developer.nfc.readersession.formats</key>
*       <array>
*         <string>NDEF</string>
*       </array>
*     </dict>
*   </entitlements>
*
* Also, ensure to include the NFC-privacy key in your <ios> section of your tiapp.xml
*
*    <plist>
*      <dict>
*        <!-- Your other Info.plist settings -->
*        ...
*        <key>NFCReaderUsageDescription</key>
*        <string>YOUR_PRIVACY_DESCRIPTION</string>
*      </dict>
*    </plist>
*
* Finally, ensure to enable the "NFC Tag Reading" capability in your provisioning profile
* by checking it in the Apple Developer Center (https://developer.apple.com).
*/

var nfc = require('ti.nfc');
var logs = [];
var ndefTagTechnology;
var sessionType = ({type:nfc.READER_SESSION_NFC_NDEF, pollingOptions: [nfc.NFC_TAG_ISO14443]}    )
var nfcAdapter = nfc.createNfcAdapter({
onNdefDiscovered: handleDiscovery
});

function handleDiscovery(e) {
    // Add rows for the message, tag, and each of the records
    var data = [];
    Ti.API.warn(e);
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

//Invalidate Session
function invalidateSession () {
    nfcAdapter.invalidate(sessionType);
}

// Configure UI
var deviceWindow = Ti.UI.createWindow({
  backgroundColor: 'white',
  title: 'NDEF Sample',
  titleAttributes: { color: 'blue' }
});

var navDeviceWindow = Ti.UI.iOS.createNavigationWindow({
  window: deviceWindow
});

//Scan button
var startSearchButton = Titanium.UI.createButton({
  top: 100,
  title: 'Scan and send NDEF connect command'
});
var startSearchButtonClick = (e) => {
    if (!nfcAdapter.isEnabled(sessionType)) {
        Ti.API.error('This device does not support NFC capabilities!');
        return;
    }
    nfcAdapter.begin(sessionType); // This is required for iOS only. Use "invalidate()" to invalidate a session.
};

//Query NDEF status button
var queryNdefStatusButton = Titanium.UI.createButton({
  top: 140,
  title: 'Query NDEF status'
});
var queryNdefStatusButtonClick = (e) => {
    if (ndefTagTechnology) {
        ndefTagTechnology.queryNDEFStatus();
    } else {
        alert('No NDEF tag available to query status');
    }
};

//Read NDEF button
var readNdefButton = Titanium.UI.createButton({
  top: 180,
  title: 'Read NDEF'
});
var readNdefButtonClick = (e) => {
    if (ndefTagTechnology) {
        ndefTagTechnology.readNDEF();
    } else {
        alert('No NDEF tag available to read');
    }
};

//Clear logs button
var clearLogButton = Titanium.UI.createButton({
    top: 220,
    color: 'red',
    title: 'Clear Log'
});
var clearLogButtonClick = (e) => {
    logs.splice(0, logs.length);
    setData(logs);
};

//Module Event Handler
//Tag events
var didConnectTag = (e) => {
    var eventMessage = 'didConnectTag with message' + (e.errorCode ? (' error code: ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description: ' + e.errorDescription) : ': NDEF Tag Connected');
    Ti.API.info(eventMessage);
    logs.push(eventMessage);
    setData(logs);
};

var didQueryNDEFStatus = (e) => {
    switch (e.status) {
        case nfc.NFC_NDEF_NOT_SUPPORTED:
            logs.push('NDEF tag not supported');
            break;
            
        case BLE.NFC_NDEF_READ_ONLY:
            logs.push('NDEF tag read only');
            break;
            
        case BLE.NFC_NDEF_READ_WRITE:
            logs.push('NDEF tag read and write and write');
            break;
        default:
            break;
    }
    setData(logs);
    
    var eventMessage = 'Query status with - error code ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description ' + e.errorDescription + ' status ' + e.status + ' capacity ' + e.capacity;
    Ti.API.info(eventMessage);
};

var didReadNDEFMessage = (e) => {
    var eventMessage = 'Query status with - error code ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description ' + e.errorDescription + ' message ' + e.message;
    Ti.API.info(eventMessage);
    logs.push('NDEF message read object ' + e.message);
    setData(logs);
};

//Session Events
var tagReaderSessionDidBecomeActive = (e) => {
    var eventMessage = 'tagReaderSessionDidBecomeActive with - error code ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description ' + e.errorDescription;
    Ti.API.info(eventMessage);
    logs.push(eventMessage);
    setData(logs);
};

var didDetectTags = (e) => {
    Ti.API.info('didDetectTags ' + e);
    logs.push('didDetectTags with message' + (e.errorCode ? (' error code: ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description: ' + e.errorDescription) : ': Tag Detected'));
    setData(logs);
    ndefTagTechnology = nfcAdapter.createTagTechNdef({'tag':e.tags[0]});//Create Tag Technology
    if (ndefTagTechnology){
        addNDEFTagEvent();//Register Event
        ndefTagTechnology.connect();
    } else {
        alert('No NDEF tag available to connect');
    }
};

var didInvalidateWithError = (e) => {
    var eventMessage = 'Invalidate the session with - error code ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description ' + e.errorDescription
  Ti.API.info(eventMessage);
  logs.push(eventMessage);
  setData(logs);
};

//Add Event Listners
nfcAdapter.addEventListener('tagReaderSessionDidBecomeActive', tagReaderSessionDidBecomeActive);
nfcAdapter.addEventListener('didDetectTags', didDetectTags);
nfcAdapter.addEventListener('didInvalidateWithError', didInvalidateWithError);

startSearchButton.addEventListener('click', startSearchButtonClick);
clearLogButton.addEventListener('click', clearLogButtonClick);
queryNdefStatusButton.addEventListener('click', queryNdefStatusButtonClick);
readNdefButton.addEventListener('click', readNdefButtonClick);

function addNDEFTagEvent(){
    ndefTagTechnology.addEventListener('didConnectTag', didConnectTag);
    ndefTagTechnology.addEventListener('didQueryNDEFStatus', didQueryNDEFStatus);
    ndefTagTechnology.addEventListener('didReadNDEFMessage', didReadNDEFMessage);
}

//Logs tableview
var tableView = Titanium.UI.createTableView({
  top: 250,
  scrollable: true,
  backgroundColor: 'White',
  separatorColor: '#DBE1E2',
  bottom: '5%',
});
var tbl_data = [];
function setData(list) {
  tbl_data.splice(0, tbl_data.length);
  if (list.length > 0) {
      var initalValue = list.length - 1;
      for (var i = initalValue; i >= 0; i--) {
          var btDevicesRow = Ti.UI.createTableViewRow({
              height: 50,
              row: i,
              hasChild: true
          });
          var uuidLabel = Ti.UI.createLabel({
              left: 5,
              right: 5,
              color: 'blue',
              top: 5,
              font: { fontSize: 11 },
              text: list[i]
          });
          btDevicesRow.add(uuidLabel);
          tbl_data.push(btDevicesRow);
      }
  }
  tableView.setData(tbl_data);
}
setData(logs);

//Add all UI to window
navDeviceWindow.add(startSearchButton);
navDeviceWindow.add(queryNdefStatusButton);
navDeviceWindow.add(readNdefButton);
navDeviceWindow.add(clearLogButton);
navDeviceWindow.add(tableView);

//Remove all events
navDeviceWindow.addEventListener('close', function () {
    nfcAdapter.removeEventListener('tagReaderSessionDidBecomeActive', didUpdateState);
    nfcAdapter.removeEventListener('didDetectTags', didStartAdvertising);
    nfcAdapter.removeEventListener('didInvalidateWithError', didStartAdvertising);
    if(ndefTagTechnology) {
        ndefTagTechnology.removeEventListener('didConnectTag', didConnectTag);
        ndefTagTechnology.removeEventListener('didQueryNDEFStatus', didQueryNDEFStatus);
        ndefTagTechnology.removeEventListener('didReadNDEFMessage', didReadNDEFMessage);
    }
    startSearchButton.removeEventListener('click', startSearchButtonClick);
    clearLogBtn.removeEventListener('click', clearLogButtonClick);
    queryNdefStatusButton.removeEventListener('click', queryNdefStatusButtonClick);
    readNdefButton.removeEventListener('click', readNdefButtonClick);
    invalidateSession();
});

navDeviceWindow.open();
