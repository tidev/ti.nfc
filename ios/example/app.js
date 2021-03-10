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
var sessionType = ({type:nfc.READER_SESSION_NFC_TAG, pollingOptions: [nfc.NFC_TAG_ISO14443]}    )
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


// Configure UI
var deviceWindow = Ti.UI.createWindow({
  backgroundColor: 'white',
  title: 'Mifare Sample',
  titleAttributes: { color: 'blue' }
});
var navDeviceWindow = Ti.UI.iOS.createNavigationWindow({
  window: deviceWindow
});

var startSearchBtn = Titanium.UI.createButton({
  top: 100,
  title: 'Scan and send mifare connect command'
});

startSearchBtn.addEventListener('click', function() {
  if (!nfcAdapter.isEnabled(sessionType)) {
  Ti.API.error('This device does not support NFC capabilities!');
  return;
}
nfcAdapter.begin(sessionType); // This is required for iOS only. Use "invalidate()" to invalidate a session.
});
nfcAdapter.addEventListener('didDetectTags', function (e) {
    Ti.API.info('didDetectTags with message' + (e.errorCode ? (' error code: ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description: ' + e.errorDescription) : ': Tag Detected'));
    logs.push('didDetectTags with message' + (e.errorCode ? (' error code: ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description: ' + e.errorDescription) : ': Tag Detected'));
    setData(logs);
    
  var mifare = nfcAdapter.createTagTechMifareUltralight({'tag':e.tags[0]});
  mifare.addEventListener('didConnectTag', function (e) {
      Ti.API.info('didConnectTag with message' + (e.errorCode ? (' error code: ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description: ' + e.errorDescription) : ': MiFare Tag Connected'));
      logs.push('didConnectTag with message' + (e.errorCode ? (' error code: ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description: ' + e.errorDescription) : ': MiFare Tag Connected'));
      setData(logs);
      var sendMiFareCommand = mifare.sendMiFareCommand({data: [0x30,0x04]})
      mifare.addEventListener('didSendMiFareCommand', function (e) {
          Ti.API.info('didSendMiFareCommand with message' + (e.errorCode ? (' error code: ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description: ' + e.errorDescription) : ': Mifare Command Send to read page data'));
          logs.push('didSendMiFareCommand with message' + (e.errorCode ? (' error code: ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description: ' + e.errorDescription) : ': Mifare Command Send to read page data'));
          logs.push('Length of response object : ' + e.responseDataLength);
          setData(logs);
      });
      nfcAdapter.invalidate(sessionType);
  });
   if (mifare){
  mifare.connect({mifare});
   }else {
       alert('No mifare tag available to connect');
   }
});
nfcAdapter.addEventListener('didInvalidateWithError', function (e) {
  Ti.API.info('Invalidate the session with - error code ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description ' + e.errorDescription);
  logs.push('Invalidate the session with - error code ' + e.errorCode + ' error domain: ' + e.errorDomain + ' error description ' + e.errorDescription);
  setData(logs);
});
var clearLogBtn = Titanium.UI.createButton({
  left: 50,
  top: 150,
  title: 'Clear Log'
});

clearLogBtn.addEventListener('click', function() {
    logs.splice(0, logs.length);
        setData(logs);
});
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

navDeviceWindow.add(startSearchBtn, clearLogBtn, tableView);

navDeviceWindow.open();
