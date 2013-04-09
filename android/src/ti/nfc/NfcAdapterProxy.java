/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc;

import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.AsyncResult;
import org.appcelerator.kroll.common.TiMessenger;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.proxy.IntentProxy;

import android.app.Activity;
import android.content.Intent;
import android.nfc.NdefMessage;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.nfc.NfcAdapter.CreateNdefMessageCallback;
import android.nfc.NfcAdapter.OnNdefPushCompleteCallback;
import android.nfc.NfcEvent;
import android.os.Build;
import android.os.Message;
import android.os.Parcelable;
import android.util.Log;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = {
	NfcConstants.PROPERTY_ON_PUSH_COMPLETE,
	NfcConstants.PROPERTY_ON_PUSH_MESSAGE,
	NfcConstants.PROPERTY_ON_NDEF_DISCOVERED,
	NfcConstants.PROPERTY_ON_TAG_DISCOVERED,
	NfcConstants.PROPERTY_ON_TECH_DISCOVERED
})
public class NfcAdapterProxy extends KrollProxy implements CreateNdefMessageCallback, OnNdefPushCompleteCallback 
{
	private NfcAdapter _adapter;

	private static final int MSG_FIRST_ID = KrollProxy.MSG_LAST_ID + 1;
   	private static final int MSG_DISABLE_FOREGROUND_DISPATCH = MSG_FIRST_ID + 100;
   	private static final int MSG_ENABLE_FOREGROUND_DISPATCH = MSG_FIRST_ID + 101;
   	private static final int MSG_DISABLE_FOREGROUND_NDEF_PUSH = MSG_FIRST_ID + 102;
   	private static final int MSG_ENABLE_FOREGROUND_NDEF_PUSH = MSG_FIRST_ID + 103;
   	
	public NfcAdapterProxy() {
		super();
	}

	@Override
	public void handleCreationArgs(KrollModule createdInModule, Object[] args) {
		// The NFC Adapter is associated with an activity. So get the current
		// activity when the adapter is created.
		Activity activity = TiApplication.getAppCurrentActivity();
		if (activity == null) {
			Log.e(NfcConstants.LCAT, "Current activity is null");
			return;
		}
		
		_adapter = NfcAdapter.getDefaultAdapter(activity);
		if (_adapter == null) {
			Log.w(NfcConstants.LCAT, "NfcAdapter is not available on this device");
			return;
		}

		// Make sure that the adapter has been set before calling the superclass
		// since some of the properties rely on the adapter being set first.
		super.handleCreationArgs(createdInModule, args);
		
		// In the case where the activity is being started by an NFC Intent, we need to
		// process the intent so that it acts as if the message was just received.
		// This removes the need for the JS application to handle this case.
		Intent intent = activity.getIntent();
		if (intent != null) {
			processIntent(intent);
		}
	}
	
	@Override
	public void handleCreationDict(KrollDict kd) {
		super.handleCreationDict(kd);
		
		if (kd.containsKey(NfcConstants.PROPERTY_ON_PUSH_MESSAGE)) {
			setPushMessageCallback(kd.get(NfcConstants.PROPERTY_ON_PUSH_MESSAGE));
		}
		if (kd.containsKey(NfcConstants.PROPERTY_ON_PUSH_COMPLETE)) {
			setPushCompleteCallback(kd.get(NfcConstants.PROPERTY_ON_PUSH_COMPLETE));
		}
	}

	@Override
	public void onNdefPushComplete(NfcEvent arg) {
		dispatchCallback(NfcConstants.PROPERTY_ON_PUSH_COMPLETE, null);
	}
	
	@Override
	public void onPropertyChanged(String name, Object value)
	{
		if (name.equals(NfcConstants.PROPERTY_ON_PUSH_MESSAGE)) {
			setPushMessageCallback(value);
		} else if (name.equals(NfcConstants.PROPERTY_ON_PUSH_COMPLETE)) {
			setPushCompleteCallback(value);
		}
		
		super.onPropertyChanged(name, value);
	}

	@Override
	public NdefMessage createNdefMessage(NfcEvent arg) {
		// We need to call the registered callback method to get the NdefMessage
		// to return. If the callback does not return a valid NdefMessage then we
		// fall back to the default
		KrollFunction callback = (KrollFunction)getProperty(NfcConstants.PROPERTY_ON_PUSH_MESSAGE);
		if (callback != null) {
			HashMap<String, String> event = new HashMap<String, String>();
			Object result = callback.call(getKrollObject(), event);
			if (result instanceof NdefMessageProxy) {
				NdefMessageProxy proxy = (NdefMessageProxy)result;
				return proxy.getMessage();
			}
		}
		return null;
	}
	
	private void setPushMessageCallback(Object value) {
		// The push message callback allows the application to return a different NDEF message
		// with each request. If the callback is set, then any NDEF message set with setNdefPushMessage
		// is ignored.
		_adapter.setNdefPushMessageCallback((value != null) ? this : null, TiApplication.getAppCurrentActivity());		
	}
	
	private void setPushCompleteCallback(Object value) {
		_adapter.setOnNdefPushCompleteCallback((value != null) ? this : null, TiApplication.getAppCurrentActivity());
	}
	
	private void dispatchCallback(String name, KrollDict data) {
		KrollFunction callback = (KrollFunction)getProperty(name);
		if (callback != null) {
			callback.callAsync(getKrollObject(), data);
		}
	}
	
	private void processIntent(Intent intent) {
		// Verify that we have an intent AND that the intent has an action
		if ((intent == null) || (intent.getAction() == null)) {
			return;
		}
		
		String action = intent.getAction();
		String name;
		
		if (action.equals(NfcAdapter.ACTION_NDEF_DISCOVERED)) {
			name = NfcConstants.PROPERTY_ON_NDEF_DISCOVERED;
		} else if (action.equals(NfcAdapter.ACTION_TAG_DISCOVERED)) {
			name = NfcConstants.PROPERTY_ON_TAG_DISCOVERED;
		} else if (action.equals(NfcAdapter.ACTION_TECH_DISCOVERED)) {
			name = NfcConstants.PROPERTY_ON_TECH_DISCOVERED;
		} else {
			return;
		}
			
		KrollDict event = new KrollDict();
		event.put(NfcConstants.PROPERTY_ACTION, action);
   			
		// Parse messages (if provided)
		Parcelable[] rawMsgs = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);
		if (rawMsgs != null) {
			NdefMessageProxy[] messages = NdefMessageProxy.parse(rawMsgs);
			if (messages != null) {
				event.put(NfcConstants.PROPERTY_MESSAGES, messages);
			} else {
				Log.i(NfcConstants.LCAT, action + " message parsing return no messages");
			}
		} else {
			Log.i(NfcConstants.LCAT, action + " intent received with no messages");
		}
		   	
		// Grab the tag
   		Tag tag = intent.getParcelableExtra(NfcAdapter.EXTRA_TAG);
   		if (tag != null) {
   			NfcTagProxy tagProxy = new NfcTagProxy(tag);
   			event.put(NfcConstants.PROPERTY_TAG, tagProxy);
   		}
   			
   		dispatchCallback(name, event);	
	}
	
	@Kroll.method
	public Boolean isEnabled() {
		return (_adapter != null) ? _adapter.isEnabled() : false;
	}
	
	@Kroll.method
	public Boolean isNdefPushEnabled() {
		return (_adapter != null) ? _adapter.isNdefPushEnabled() : false;
	}
	
	@Kroll.method
	public void onNewIntent(IntentProxy intentProxy) {
		if (intentProxy != null) {
			processIntent(intentProxy.getIntent());
		}
	}

	@Kroll.method
	public void disableForegroundDispatch() {
		// This function must be run on the main UI thread
		if (TiApplication.isUIThread()) {
			handleDisableForegroundDispatch();
		} else {
			TiMessenger.sendBlockingMainMessage(getMainHandler().obtainMessage(MSG_DISABLE_FOREGROUND_DISPATCH));
		}
	}
	
	@Kroll.method
	public void disableForegroundNdefPush() {
    	if (Build.VERSION.SDK_INT >= 14) {
    		Log.d(NfcConstants.LCAT, "disableForegroundNdefPush was deprecated in API level 14. Use setNdefPushMessage instead");
    		return;
    	}
    	
		// This function must be run on the main UI thread
		if (TiApplication.isUIThread()) {
			handleDisableForegroundNdefPush();
		} else {
			TiMessenger.sendBlockingMainMessage(getMainHandler().obtainMessage(MSG_DISABLE_FOREGROUND_NDEF_PUSH));
		}
	}
	
	@Kroll.method
	public void enableForegroundDispatch(NfcForegroundDispatchFilter filter) {
		if (filter == null) {
			throw new IllegalArgumentException("Filter argument is required");
		}
		
		// This function must be run on the main UI thread
		if (TiApplication.isUIThread()) {
			handleEnableForegroundDispatch(filter);
		} else {
			TiMessenger.sendBlockingMainMessage(getMainHandler().obtainMessage(MSG_ENABLE_FOREGROUND_DISPATCH), filter);
		}
	}

	@Kroll.method
	public void enableForegroundNdefPush(NdefMessageProxy message) {
    	if (Build.VERSION.SDK_INT >= 14) {
    		Log.d(NfcConstants.LCAT, "enableForegroundNdefPush was deprecated in API level 14. Use setNdefPushMessage instead");
    		return;
    	}

		if (message == null) {
			throw new IllegalArgumentException("Message argument is required");
		}
		
		// This function must be run on the main UI thread
		if (TiApplication.isUIThread()) {
			handleEnableForegroundNdefPush(message.getMessage());
		} else {
			TiMessenger.sendBlockingMainMessage(getMainHandler().obtainMessage(MSG_ENABLE_FOREGROUND_NDEF_PUSH), message.getMessage());
		}
	}
	
	@Kroll.method
	public void setNdefPushMessage(NdefMessageProxy message) {
    	if (Build.VERSION.SDK_INT < 14) {
    		Log.w(NfcConstants.LCAT, "setNdefPushMessage is not available until API level 14");
    		return;
    	}		
    	
    	_adapter.setNdefPushMessage((message != null) ? message.getMessage() : null, TiApplication.getAppCurrentActivity());
	}
	
	@Override
	public boolean handleMessage(Message msg)
	{
		switch(msg.what){
			case MSG_DISABLE_FOREGROUND_DISPATCH: {
				AsyncResult result = (AsyncResult)msg.obj;
				try {
					handleDisableForegroundDispatch();
					result.setResult(null);
				} catch (Exception e) {
					result.setResult(e);
				}
				return true;
			}
			case MSG_ENABLE_FOREGROUND_DISPATCH: {
				AsyncResult result = (AsyncResult)msg.obj;
				try {
					handleEnableForegroundDispatch((NfcForegroundDispatchFilter)result.getArg());
					result.setResult(null);
				} catch (Exception e) {
					result.setResult(e);
				}
				return true;
			}
			case MSG_DISABLE_FOREGROUND_NDEF_PUSH: {
				AsyncResult result = (AsyncResult)msg.obj;
				try {
					handleDisableForegroundNdefPush();
					result.setResult(null);
				} catch (Exception e) {
					result.setResult(e);
				}
				return true;
			}
			case MSG_ENABLE_FOREGROUND_NDEF_PUSH: {
				AsyncResult result = (AsyncResult)msg.obj;
				try {
					handleEnableForegroundNdefPush((NdefMessage)result.getArg());
					result.setResult(null);
				} catch (Exception e) {
					result.setResult(e);
				}
				return true;
			}
		}
		return super.handleMessage(msg);
	}
	
	private void handleDisableForegroundDispatch() {
		_adapter.disableForegroundDispatch(TiApplication.getAppCurrentActivity());
	}
	
	private void handleEnableForegroundDispatch(NfcForegroundDispatchFilter filter) {
		if (filter != null) {
			_adapter.enableForegroundDispatch(TiApplication.getAppCurrentActivity(), 
        		filter.getPendingIntent(), filter.getIntentFilters(), filter.getTechLists());
		}
	}
	
	@SuppressWarnings("deprecation")
	private void handleDisableForegroundNdefPush() {
		_adapter.disableForegroundNdefPush(TiApplication.getAppCurrentActivity());
	}
	
	@SuppressWarnings("deprecation")
	private void handleEnableForegroundNdefPush(NdefMessage message) {
		_adapter.enableForegroundNdefPush(TiApplication.getAppCurrentActivity(), message);
	}
}
