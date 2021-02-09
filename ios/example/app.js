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
const IOS = (Ti.Platform.osname === 'iphone' || Ti.Platform.osname === 'ipad');
const ANDROID = (Ti.Platform.osname === 'android');
var nfc = require('ti.nfc');
var sessionType = ({type:nfc.READER_SESSION_NFC_TAG, pollingOptions: [nfc.NFC_TAG_ISO14443]})
var session = ({type:nfc.READER_SESSION_NFC_TAG})
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

var win = Ti.UI.createWindow({
  backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
  title: 'Start Search'
});

btn.addEventListener('click', function() {
    if (!nfcAdapter.isEnabled(session)) {
    Ti.API.error('This device does not support NFC capabilities!');
    return;
  }
    if (IOS){
        nfcAdapter.begin(sessionType);
    }// This is required for iOS only. Use "invalidate()" to invalidate a session.
});

nfcAdapter.addEventListener('didDetectTags', function (e) {
    var mifare = nfcAdapter.createTagTechMifareUltralight({'tag':e.tags[0]});
    mifare.addEventListener('didConnectTag', function (e) {
        Ti.API.info('Connected tag object : ' + e.tag);
        alert('Tag Connected: ' + e.tag);
    });
    mifare.connect({mifare});
    
       var identifier = mifare.identifier;
       var historicalBytes = mifare.historicalBytes;
       var sendMiFareCommand = mifare.sendMiFareCommand({data:[0xA0, 0x00]});
       Ti.API.info('Connected tag object : ' + response);
       alert('Tag Connected: ' + responseData);
    
       var sendMiFareISO7816Command = mifare.sendMiFareISO7816Command({instructionClass: 0, instructionCode: 0, p1Parameter: 0, p2Parameter: 0, expectedResponseLength: 16, data:[0xA0, 0x00]});
        Ti.API.info('Connected tag object : ' + response);
        alert('Tag Connected: ' + response);
      nfcAdapter.invalidate(sessionType);
});
nfcAdapter.addEventListener('didInvalidateWithError', function (e) {
        Ti.API.info('code: ' + e.code);
});

win.add(btn);
win.open();
