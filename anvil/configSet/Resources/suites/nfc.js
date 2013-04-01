/*
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

module.exports = new function ()
{
	var finish;
	var valueOf;
	var nfc;
	this.init = function (testUtils)
	{
		finish = testUtils.finish;
		valueOf = testUtils.valueOf;

		nfc = require('ti.nfc');
	};

	this.name = "ti.nfc";

	// Test that module is loaded
	this.testModule = function (testRun)
	{
		// Verify that the module is defined
		valueOf(testRun, nfc).shouldBeObject();

		finish(testRun);
	};

	// Test that all of the constants are defined
	this.testConstants = function (testRun)
	{
		// Verify that all of the constants are exposed
		valueOf(testRun, nfc.TNF_ABSOLUTE_URI).shouldBeNumber();
		valueOf(testRun, nfc.TNF_EMPTY).shouldBeNumber();
		valueOf(testRun, nfc.TNF_EXTERNAL_TYPE).shouldBeNumber();
		valueOf(testRun, nfc.TNF_MIME_MEDIA).shouldBeNumber();
		valueOf(testRun, nfc.TNF_UNCHANGED).shouldBeNumber();
		valueOf(testRun, nfc.TNF_UNKNOWN).shouldBeNumber();
		valueOf(testRun, nfc.TNF_WELL_KNOWN).shouldBeNumber();
		
		valueOf(testRun, nfc.ENCODING_UTF8).shouldBeString();
		valueOf(testRun, nfc.ENCODING_UTF16).shouldBeString();

		valueOf(testRun, nfc.RTD_ALTERNATIVE_CARRIER).shouldBeString();
		valueOf(testRun, nfc.RTD_HANDOVER_CARRIER).shouldBeString();
		valueOf(testRun, nfc.RTD_HANDOVER_REQUEST).shouldBeString();
		valueOf(testRun, nfc.RTD_HANDOVER_SELECT).shouldBeString();
		valueOf(testRun, nfc.RTD_SMART_POSTER).shouldBeString();
		valueOf(testRun, nfc.RTD_TEXT).shouldBeString();
		valueOf(testRun, nfc.RTD_URI).shouldBeString();
		
		valueOf(testRun, nfc.ACTION_NDEF_DISCOVERED).shouldBeString();
		valueOf(testRun, nfc.ACTION_TAG_DISCOVERED).shouldBeString();
		valueOf(testRun, nfc.ACTION_TECH_DISCOVERED).shouldBeString();
		
		valueOf(testRun, nfc.RECOMMENDED_ACTION_UNKNOWN).shouldBeNumber();
		valueOf(testRun, nfc.RECOMMENDED_ACTION_DO_ACTION).shouldBeNumber();
		valueOf(testRun, nfc.RECOMMENDED_ACTION_SAVE_FOR_LATER).shouldBeNumber();
		valueOf(testRun, nfc.RECOMMENDED_ACTION_OPEN_FOR_EDITING).shouldBeNumber();
		
		valueOf(testRun, nfc.TECH_ISODEP).shouldBeString();
		valueOf(testRun, nfc.TECH_MIFARE_CLASSIC).shouldBeString();
		valueOf(testRun, nfc.TECH_MIFARE_ULTRALIGHT).shouldBeString();
		valueOf(testRun, nfc.TECH_NDEF).shouldBeString();
		valueOf(testRun, nfc.TECH_NDEFFORMATABLE).shouldBeString();
		valueOf(testRun, nfc.TECH_NFCA).shouldBeString();
		valueOf(testRun, nfc.TECH_NFCB).shouldBeString();
		valueOf(testRun, nfc.TECH_NFCF).shouldBeString();
		valueOf(testRun, nfc.TECH_NFCV).shouldBeString();

		finish(testRun);
	};

	this.testAdapterProxy = function (testRun)
	{
		var adapter = nfc.createNfcAdapter();

		valueOf(testRun, adapter).shouldBeObject();

		// Verify that all of the methods are exposed
		valueOf(testRun, adapter.isEnabled).shouldBeFunction();
		valueOf(testRun, adapter.isNdefPushEnabled).shouldBeFunction();
		valueOf(testRun, adapter.onNewIntent).shouldBeFunction();
		valueOf(testRun, adapter.disableForegroundDispatch).shouldBeFunction();
		valueOf(testRun, adapter.disableForegroundNdefPush).shouldBeFunction();
		valueOf(testRun, adapter.enableForegroundDispatch).shouldBeFunction();
		valueOf(testRun, adapter.enableForegroundNdefPush).shouldBeFunction();
		valueOf(testRun, adapter.setNdefPushMessage).shouldBeFunction();

		finish(testRun);
	};

	// Test property setting
	this.testAdapterProperties = function (testRun)
	{
		var adapter = nfc.createNfcAdapter();

		valueOf(testRun, adapter).shouldBeObject();

		// Verify that all of the properties handled get/set
		valueOf(testRun, adapter.onPushComplete).shouldBeUndefined();
		valueOf(testRun, adapter.onPushMessage).shouldBeUndefined();
		valueOf(testRun, adapter.onNdefDiscovered).shouldBeUndefined();
		valueOf(testRun, adapter.onTagDiscovered).shouldBeUndefined();
		valueOf(testRun, adapter.onTechDiscovered).shouldBeUndefined();

		// The following calls can only be made on a device. They will
		// fail on simulator because setting these properties results
		// in calls to set values on the NFC adapater.
		if (Ti.Platform.model === 'Simulator' || Ti.Platform.model.indexOf('sdk') !== -1 ) {
			// Running on simulator
		} else {
			function dummyFunction() {}

			adapter.onPushComplete = dummyFunction;
			adapter.onPushMessage = dummyFunction;
			adapter.onNdefDiscovered = dummyFunction;
			adapter.onTagDiscovered = dummyFunction;
			adapter.onTechDiscovered = dummyFunction;

			valueOf(testRun, adapter.onPushComplete).shouldBe(dummyFunction);
			valueOf(testRun, adapter.onPushMessage).shouldBe(dummyFunction);
			valueOf(testRun, adapter.onNdefDiscovered).shouldBe(dummyFunction);
			valueOf(testRun, adapter.onTagDiscovered).shouldBe(dummyFunction);
			valueOf(testRun, adapter.onTechDiscovered).shouldBe(dummyFunction);
		}	

		finish(testRun);
	};

	// Helper function to verify the superclass of type-specific records
	function verifyNdefRecord(testRun, record) {
		valueOf(testRun, record.getRecordType).shouldBeFunction();
		valueOf(testRun, record.getId).shouldBeFunction();
		valueOf(testRun, record.getTnf).shouldBeFunction();
		valueOf(testRun, record.getType).shouldBeFunction();
		valueOf(testRun, record.getHashCode).shouldBeFunction();

		valueOf(testRun, record.recordType).shouldBeString();
		// The following fields are only valid for received records, not created records
		valueOf(testRun, record.id).shouldBeNull();
		valueOf(testRun, record.tnf).shouldBeNumber();
		valueOf(testRun, record.type).shouldBeNull();
		valueOf(testRun, record.hashCode).shouldBeNumber();
	}

	this.testApplicationRecord = function (testRun)
	{
		var record = nfc.createNdefRecordApplication({
			packageName: 'com.appcelerator.testapp'
		});

		valueOf(testRun, record).shouldBeObject();
		valueOf(testRun, record.packageName).shouldBe('com.appcelerator.testapp');

		// Verify the superclass
		valueOf(testRun, record.recordType).shouldBe('NdefRecordApplication');
		verifyNdefRecord(testRun, record);

		finish(testRun);
	}

	this.testEmptyRecord = function (testRun)
	{
		var record = nfc.createNdefRecordEmpty({});

		valueOf(testRun, record).shouldBeObject();

		// Verify the superclass
		valueOf(testRun, record.recordType).shouldBe('NdefRecordEmpty');
		verifyNdefRecord(testRun, record);

		finish(testRun);
	}

	this.testExternalRecord = function (testRun)
	{
		var record = nfc.createNdefRecordExternal({
			domain: 'testDomain',
			domainType: 'test/test'
		});

		valueOf(testRun, record).shouldBeObject();
		valueOf(testRun, record.domain).shouldBe('testDomain');
		valueOf(testRun, record.domainType).shouldBe('test/test');

		// Verify the superclass
		valueOf(testRun, record.recordType).shouldBe('NdefRecordExternal');
		verifyNdefRecord(testRun, record);

		finish(testRun);
	}

	this.testMediaRecord = function (testRun)
	{
		var test = "This is a test string";
		var blob = Ti.Utils.base64encode(test);

		var record = nfc.createNdefRecordMedia({
			mimeType: 'text/plain',
			payload: blob
		});

		valueOf(testRun, record).shouldBeObject();
		valueOf(testRun, record.mimeType).shouldBe('text/plain');
		var result = Ti.Utils.base64decode(record.payload);
		valueOf(testRun, result).shouldBe(test);

		// Verify the superclass
		valueOf(testRun, record.recordType).shouldBe('NdefRecordMedia');
		verifyNdefRecord(testRun, record);

		finish(testRun);
	}	

	this.testSmartPosterRecord = function (testRun)
	{
		var record = nfc.createNdefRecordSmartPoster({
			title: 'testTitle',
			uri: 'http://www.appcelerator.com',
			action: nfc.RECOMMENDED_ACTION_DO_ACTION,
			mimeType: 'test/test'
		});

		valueOf(testRun, record).shouldBeObject();
		valueOf(testRun, record.title).shouldBe('testTitle');
		valueOf(testRun, record.uri).shouldBe('http://www.appcelerator.com');
		valueOf(testRun, record.action).shouldBe(nfc.RECOMMENDED_ACTION_DO_ACTION);
		valueOf(testRun, record.mimeType).shouldBe('test/test');

		// Verify the superclass
		valueOf(testRun, record.recordType).shouldBe('NdefRecordSmartPoster');
		verifyNdefRecord(testRun, record);

		finish(testRun);
	}

	this.testTextRecord = function (testRun)
	{
		var record = nfc.createNdefRecordText({
			text: 'Hello World',
			languageCode: 'en',
			encoding: nfc.ENCODING_UTF8
		});

		valueOf(testRun, record).shouldBeObject();
		valueOf(testRun, record.text).shouldBe('Hello World');
		valueOf(testRun, record.languageCode).shouldBe('en');
		valueOf(testRun, record.encoding).shouldBe(nfc.ENCODING_UTF8);

		// Verify the superclass
		valueOf(testRun, record.recordType).shouldBe('NdefRecordText');
		verifyNdefRecord(testRun, record);

		finish(testRun);
	}

	this.testUriRecord = function (testRun)
	{
		var record = nfc.createNdefRecordUri({
			uri: 'http://www.appcelerator.com'
		});

		valueOf(testRun, record).shouldBeObject();
		valueOf(testRun, record.uri).shouldBe('http://www.appcelerator.com');

		// Verify the superclass
		valueOf(testRun, record.recordType).shouldBe('NdefRecordUri');
		verifyNdefRecord(testRun, record);

		finish(testRun);
	}

	this.testMessage = function (testRun)
	{
		var record1 = nfc.createNdefRecordText({
			text: 'Hello World'
		});
		var record2 = nfc.createNdefRecordUri({
			uri: 'http://www.appcelerator.com'
		});
		var message = nfc.createNdefMessage({
			records: [
				record1,
				record2
			]
		});

		valueOf(testRun, message).shouldBeObject();
		valueOf(testRun, message.toByte).shouldBeFunction();

		valueOf(testRun, message.records).shouldBeArray();
		valueOf(testRun, message.records.length).shouldBe(2);
		valueOf(testRun, message.records[0].getRecordType()).shouldBe('NdefRecordText');
		valueOf(testRun, message.records[0].getText()).shouldBe('Hello World');
		valueOf(testRun, message.records[1].getRecordType()).shouldBe('NdefRecordUri');
		valueOf(testRun, message.records[1].getUri()).shouldBe('http://www.appcelerator.com');

		finish(testRun);
	}

	this.testForegroundDispatchFilter = function (testRun) 
	{
		var filter = nfc.createNfcForegroundDispatchFilter({
			intentFilters: [
				{ action: nfc.ACTION_NDEF_DISCOVERED, mimeType: '*/*' },
				{ action: nfc.ACTION_NDEF_DISCOVERED, scheme: 'http', host: 'www.appcelerator.com' }
			],
			techLists: [
				[ nfc.TECH_NFCF, nfc.TECH_NFCB, nfc.TECH_MIFARE_CLASSIC ],
				[ nfc.TECH_NDEF ],
				[ nfc.TECH_MIFARE_CLASSIC ],
				[ nfc.TECH_NFCA ]
			]			
		});

		valueOf(testRun, filter).shouldBeObject();

		valueOf(testRun, filter.intent).shouldBeUndefined();
		valueOf(testRun, filter.intentFilters).shouldBeArray();
		valueOf(testRun, filter.techLists).shouldBeArray();

		finish(testRun);
	}

	// Populate the array of tests based on the 'hammer' convention
	this.tests = require('hammer').populateTests(this);
};
