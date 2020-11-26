/* eslint-disable no-alert */

function deviceWin() {
  /*
   * NFC Tag Reader session API example.
   *
   * This application demonstrates how to use the iOS 13+ NFC module.
   *
   * Ensure to include the required entitlements to the <ios> section of your tiapp.xml:
   *
   *   <entitlements>
   *     <dict>
   *       <key>com.apple.developer.nfc.readersession.formats</key>
   *       <array>
   *         <string>NDEF</string>
   *         <string>TAG</string>
   *       </array>
   *     </dict>
   *   </entitlements>
   *
   * Also, ensure to include the NFC-privacy key in your <ios> section of your tiapp.xml
   *
   *    <plist>
   *      <dict>
   *        <!-- Your other Info.plist settings -->
   *        <key>com.apple.developer.nfc.readersession.felica.systemcodes</key>
   *           <array>
   *             <string>12FC</string>
   *          </array>
   *        <key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
   *           <array>
   *             <string>D2760000850101</string>
   *          </array>
   *        <key>NFCReaderUsageDescription</key>
   *        <string>YOUR_PRIVACY_DESCRIPTION</string>
   *      </dict>
   *    </plist>
   *
   * Finally, ensure to enable the "NFC Tag Reading" capability in your provisioning profile
   * by checking it in the Apple Developer Center (https://developer.apple.com).
   */

  var nfc = require('ti.nfc');
  var tagReaderSession = nfc.createTagReaderSession();

  tagReaderSession.addEventListener('detect', function (event) {
    console.warn(event);
  });

  tagReaderSession.addEventListener('error', function (event) {
    console.error(event);
  });

  var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
  });

  var btn = Ti.UI.createButton({
    title: 'Start Search'
  });

  tagReaderSession.addEventListener('didDetectTags', function (e) {
    Ti.API.info('Did detect tags: ' + e.stringIdentifier + ' with identifier: ' + e.identifier);
    alert('The UID of the tag' + e.stringIdentifier);
    tagReaderSession.invalidate()
  });
  tagReaderSession.addEventListener('didInvalidateWithError', function (e) {
    Ti.API.info('Error: ' + e.error);
    //alert('The error : -  ' + e.error);
  });

  btn.addEventListener('click', function () {
    if (!tagReaderSession.isEnabled()) {
      Ti.API.error('This device does not support NFC capabilities!');
      return;
    }
    tagReaderSession.begin(); // Use "restartPolling()" to restart tag polling.
  });

  var backButton = Titanium.UI.createButton({
    bottom: 100,
    title: 'Close Page'
  });
  backButton.addEventListener('click', function () {
    win.close();
  });

  win.add(btn, backButton);
  return win;
}
exports.deviceWin = deviceWin;
