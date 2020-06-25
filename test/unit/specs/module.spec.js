let NFC;

const IOS = (Ti.Platform.osname === 'iphone' || Ti.Platform.osname === 'ipad');
const ANDROID = (Ti.Platform.osname === 'android');

describe('ti.nfc', () => {
	it('can be required', () => {
		NFC = require('ti.nfc');

		expect(NFC).toBeDefined();
	});

	describe('module', () => {
		it('.apiName', () => { // FIXME: Reports Ti.Module on android, Ti.Proxy on ios
			expect(NFC.apiName).toBe('Ti.NFC');
		});

		if (IOS) { // FIXME: ios only
			it('.moduleId', () => {
				expect(NFC.moduleId).toBe('ti.nfc');
			});
		}

		// TODO: guid, name
		// TODO: properties
		describe('constants', () => {
			it('.TNF_ABSOLUTE_URI', () => {
				expect(NFC.TNF_ABSOLUTE_URI).toEqual(jasmine.any(Number));
			});

			it('.TNF_EMPTY', () => {
				expect(NFC.TNF_EMPTY).toEqual(jasmine.any(Number));
			});

			it('.TNF_EXTERNAL_TYPE', () => {
				expect(NFC.TNF_EXTERNAL_TYPE).toEqual(jasmine.any(Number));
			});

			it('.TNF_MIME_MEDIA', () => {
				expect(NFC.TNF_MIME_MEDIA).toEqual(jasmine.any(Number));
			});

			it('.TNF_UNCHANGED', () => {
				expect(NFC.TNF_UNCHANGED).toEqual(jasmine.any(Number));
			});

			it('.TNF_UNKNOWN', () => {
				expect(NFC.TNF_UNKNOWN).toEqual(jasmine.any(Number));
			});

			it('.TNF_WELL_KNOWN', () => {
				expect(NFC.TNF_WELL_KNOWN).toEqual(jasmine.any(Number));
			});

			if (ANDROID) {
				it('.ACTION_NDEF_DISCOVERED', () => {
					expect(NFC.ACTION_NDEF_DISCOVERED).toEqual(jasmine.any(String));
				});

				it('.ACTION_TAG_DISCOVERED', () => {
					expect(NFC.ACTION_TAG_DISCOVERED).toEqual(jasmine.any(String));
				});

				it('.ACTION_TECH_DISCOVERED', () => {
					expect(NFC.ACTION_TECH_DISCOVERED).toEqual(jasmine.any(String));
				});

				it('.ENCODING_UTF8', () => {
					expect(NFC.ENCODING_UTF8).toEqual(jasmine.any(String));
				});

				it('.ENCODING_UTF16', () => {
					expect(NFC.ENCODING_UTF16).toEqual(jasmine.any(String));
				});

				it('.MIFARE_TAG_TYPE_CLASSIC', () => {
					expect(NFC.MIFARE_TAG_TYPE_CLASSIC).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_TAG_TYPE_PLUS', () => {
					expect(NFC.MIFARE_TAG_TYPE_PLUS).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_TAG_TYPE_PRO', () => {
					expect(NFC.MIFARE_TAG_TYPE_PRO).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_TAG_TYPE_UNKNOWN', () => {
					expect(NFC.MIFARE_TAG_TYPE_UNKNOWN).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_BLOCK_SIZE', () => {
					expect(NFC.MIFARE_BLOCK_SIZE).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_SIZE_1K', () => {
					expect(NFC.MIFARE_SIZE_1K).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_SIZE_2K', () => {
					expect(NFC.MIFARE_SIZE_2K).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_SIZE_4K', () => {
					expect(NFC.MIFARE_SIZE_4K).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_SIZE_MINI', () => {
					expect(NFC.MIFARE_SIZE_MINI).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_ULTRALIGHT_PAGE_SIZE', () => {
					expect(NFC.MIFARE_ULTRALIGHT_PAGE_SIZE).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_ULTRALIGHT_TYPE_ULTRALIGHT', () => {
					expect(NFC.MIFARE_ULTRALIGHT_TYPE_ULTRALIGHT).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_ULTRALIGHT_TYPE_ULTRALIGHT_C', () => {
					expect(NFC.MIFARE_ULTRALIGHT_TYPE_ULTRALIGHT_C).toEqual(jasmine.any(Number));
				});

				it('.MIFARE_ULTRALIGHT_TYPE_UNKNOWN', () => {
					expect(NFC.MIFARE_ULTRALIGHT_TYPE_UNKNOWN).toEqual(jasmine.any(Number));
				});

				it('.RECOMMENDED_ACTION_UNKNOWN', () => {
					expect(NFC.RECOMMENDED_ACTION_UNKNOWN).toEqual(jasmine.any(Number));
				});

				it('.RECOMMENDED_ACTION_DO_ACTION', () => {
					expect(NFC.RECOMMENDED_ACTION_DO_ACTION).toEqual(jasmine.any(Number));
				});

				it('.RECOMMENDED_ACTION_SAVE_FOR_LATER', () => {
					expect(NFC.RECOMMENDED_ACTION_SAVE_FOR_LATER).toEqual(jasmine.any(Number));
				});

				it('.RECOMMENDED_ACTION_OPEN_FOR_EDITING', () => {
					expect(NFC.RECOMMENDED_ACTION_OPEN_FOR_EDITING).toEqual(jasmine.any(Number));
				});

				it('.RTD_ALTERNATIVE_CARRIER', () => {
					expect(NFC.RTD_ALTERNATIVE_CARRIER).toEqual(jasmine.any(String));
				});

				it('.RTD_HANDOVER_CARRIER', () => {
					expect(NFC.RTD_HANDOVER_CARRIER).toEqual(jasmine.any(String));
				});

				it('.RTD_HANDOVER_REQUEST', () => {
					expect(NFC.RTD_HANDOVER_REQUEST).toEqual(jasmine.any(String));
				});

				it('.RTD_HANDOVER_SELECT', () => {
					expect(NFC.RTD_HANDOVER_SELECT).toEqual(jasmine.any(String));
				});

				it('.RTD_SMART_POSTER', () => {
					expect(NFC.RTD_SMART_POSTER).toEqual(jasmine.any(String));
				});

				it('.RTD_TEXT', () => {
					expect(NFC.RTD_TEXT).toEqual(jasmine.any(String));
				});

				it('.RTD_URI', () => {
					expect(NFC.RTD_URI).toEqual(jasmine.any(String));
				});

				it('.TAG_TYPE_NFC_FORUM_TYPE_1', () => {
					expect(NFC.TAG_TYPE_NFC_FORUM_TYPE_1).toEqual(jasmine.any(String));
				});

				it('.TAG_TYPE_NFC_FORUM_TYPE_2', () => {
					expect(NFC.TAG_TYPE_NFC_FORUM_TYPE_2).toEqual(jasmine.any(String));
				});

				it('.TAG_TYPE_NFC_FORUM_TYPE_3', () => {
					expect(NFC.TAG_TYPE_NFC_FORUM_TYPE_3).toEqual(jasmine.any(String));
				});

				it('.TAG_TYPE_NFC_FORUM_TYPE_4', () => {
					expect(NFC.TAG_TYPE_NFC_FORUM_TYPE_4).toEqual(jasmine.any(String));
				});

				it('.TAG_TYPE_MIFARE_CLASSIC', () => {
					expect(NFC.TAG_TYPE_MIFARE_CLASSIC).toEqual(jasmine.any(String));
				});

				it('.TECH_ISODEP', () => {
					expect(NFC.TECH_ISODEP).toEqual(jasmine.any(String));
				});

				it('.TECH_MIFARE_CLASSIC', () => {
					expect(NFC.TECH_MIFARE_CLASSIC).toEqual(jasmine.any(String));
				});

				it('.TECH_MIFARE_ULTRALIGHT', () => {
					expect(NFC.TECH_MIFARE_ULTRALIGHT).toEqual(jasmine.any(String));
				});

				it('.TECH_NDEF', () => {
					expect(NFC.TECH_NDEF).toEqual(jasmine.any(String));
				});

				it('.TECH_NDEFFORMATABLE', () => {
					expect(NFC.TECH_NDEFFORMATABLE).toEqual(jasmine.any(String));
				});

				it('.TECH_NFCA', () => {
					expect(NFC.TECH_NFCA).toEqual(jasmine.any(String));
				});

				it('.TECH_NFCB', () => {
					expect(NFC.TECH_NFCB).toEqual(jasmine.any(String));
				});

				it('.TECH_NFCF', () => {
					expect(NFC.TECH_NFCF).toEqual(jasmine.any(String));
				});

				it('.TECH_NFCV', () => {
					expect(NFC.TECH_NFCV).toEqual(jasmine.any(String));
				});
			}

			if (IOS) {
				it('.INVALIDATION_ERROR_USER_CANCELED', () => {
					expect(NFC.INVALIDATION_ERROR_USER_CANCELED).toEqual(jasmine.any(Number));
				});

				it('.INVALIDATION_ERROR_SESSION_TIMEOUT', () => {
					expect(NFC.INVALIDATION_ERROR_SESSION_TIMEOUT).toEqual(jasmine.any(Number));
				});

				it('.INVALIDATION_ERROR_SESSION_TERMINATED_UNEXPECTEDLY', () => {
					expect(NFC.INVALIDATION_ERROR_SESSION_TERMINATED_UNEXPECTEDLY).toEqual(jasmine.any(Number));
				});

				it('.INVALIDATION_ERROR_SYSTEM_IS_BUSY', () => {
					expect(NFC.INVALIDATION_ERROR_SYSTEM_IS_BUSY).toEqual(jasmine.any(Number));
				});

				it('.INVALIDATION_ERROR_FIRST_NDEF_TAG_READ', () => {
					expect(NFC.INVALIDATION_ERROR_FIRST_NDEF_TAG_READ).toEqual(jasmine.any(Number));
				});

				it('.ERROR_UNSUPPORTED_FEATURE', () => {
					expect(NFC.ERROR_UNSUPPORTED_FEATURE).toEqual(jasmine.any(Number));
				});

				it('.ERROR_SECURITY_VIOLATION', () => {
					expect(NFC.ERROR_SECURITY_VIOLATION).toEqual(jasmine.any(Number));
				});

				it('.TRANSCEIVE_ERROR_TAG_CONNECTION_LOST', () => {
					expect(NFC.TRANSCEIVE_ERROR_TAG_CONNECTION_LOST).toEqual(jasmine.any(Number));
				});

				it('.TRANSCEIVE_ERROR_RETRY_EXCEEDED', () => {
					expect(NFC.TRANSCEIVE_ERROR_RETRY_EXCEEDED).toEqual(jasmine.any(Number));
				});

				it('.TRANSCEIVE_ERROR_TAG_RESPONSE_ERROR', () => {
					expect(NFC.TRANSCEIVE_ERROR_TAG_RESPONSE_ERROR).toEqual(jasmine.any(Number));
				});

				it('.COMMAND_CONFIGURATION_ERROR_INVALID_PARAMETERS', () => {
					expect(NFC.COMMAND_CONFIGURATION_ERROR_INVALID_PARAMETERS).toEqual(jasmine.any(Number));
				});
			}
		});
	});
});
