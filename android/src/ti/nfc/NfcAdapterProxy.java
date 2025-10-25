/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.os.Build;
import android.os.Message;
import android.os.Parcelable;
import android.util.Log;
import java.util.ArrayList;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.AsyncResult;
import org.appcelerator.kroll.common.TiMessenger;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiFileProxy;
import org.appcelerator.titanium.proxy.IntentProxy;

@Kroll.proxy(creatableInModule = NfcModule.class,
			 propertyAccessors = { NfcConstants.PROPERTY_ON_PUSH_COMPLETE, NfcConstants.PROPERTY_ON_PUSH_MESSAGE,
								   NfcConstants.PROPERTY_ON_NDEF_DISCOVERED, NfcConstants.PROPERTY_ON_TAG_DISCOVERED,
								   NfcConstants.PROPERTY_ON_TECH_DISCOVERED, NfcConstants.PROPERTY_ON_BEAM_PUSH_URIS })
public class NfcAdapterProxy extends KrollProxy
{
	private NfcAdapter _adapter;

	private static final int MSG_FIRST_ID = KrollProxy.MSG_LAST_ID + 1;
	private static final int MSG_DISABLE_FOREGROUND_DISPATCH = MSG_FIRST_ID + 100;
	private static final int MSG_ENABLE_FOREGROUND_DISPATCH = MSG_FIRST_ID + 101;
	public NfcAdapterProxy()
	{
		super();
	}

	@Override
	public void handleCreationArgs(KrollModule createdInModule, Object[] args)
	{
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
	public void handleCreationDict(KrollDict kd)
	{
		super.handleCreationDict(kd);
	}

	@Override
	public void onPropertyChanged(String name, Object value)
	{
		super.onPropertyChanged(name, value);
	}

	private void processIntent(Intent intent)
	{
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
				Log.i(NfcConstants.LCAT, action + " message parsing returned no messages");
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

	private void dispatchCallback(String name, KrollDict data)
	{
		KrollFunction callback = (KrollFunction) getProperty(name);
		if (callback != null) {
			callback.callAsync(getKrollObject(), data);
		}
	}

	// ---------------------------------------------------------------------------
	// Base adapter methods
	// ---------------------------------------------------------------------------

	@Kroll.method
	public boolean isEnabled()
	{
		return (_adapter != null) ? _adapter.isEnabled() : false;
	}

	@Kroll.method
	public void enableReader(KrollFunction callback)
	{
		if (_adapter != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
			_adapter.enableReaderMode(TiApplication.getAppCurrentActivity(),
									  new NfcAdapter.ReaderCallback() {
										  @Override
										  public void onTagDiscovered(Tag tag)
										  {
											  KrollDict event = new KrollDict();
											  NfcTagProxy tagProxy = new NfcTagProxy(tag);
											  event.put(NfcConstants.PROPERTY_TAG, tagProxy);
											  Log.d(NfcConstants.LCAT, "tagproxy: " + tagProxy.getId());
											  callback.callAsync(getKrollObject(), event);
										  }
									  },
									  NfcAdapter.FLAG_READER_NFC_A | NfcAdapter.FLAG_READER_NFC_B
										  | NfcAdapter.FLAG_READER_NFC_F | NfcAdapter.FLAG_READER_NFC_BARCODE
										  | NfcAdapter.FLAG_READER_NFC_V | NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK
										  | NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS,
									  null);
		}
	}

	@Kroll.method
	public void disableReader()
	{
		if (_adapter != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
			_adapter.disableReaderMode(TiApplication.getAppCurrentActivity());
		}
	}

	@Kroll.method
	public void onNewIntent(IntentProxy intentProxy)
	{
		if (intentProxy != null) {
			processIntent(intentProxy.getIntent());
		}
	}

	private Uri[] getUriArrayFromArg(Object arg)
	{
		ArrayList<Uri> uriList = new ArrayList<Uri>();
		if ((arg != null) && arg.getClass().isArray()) {
			Object[] argArray = (Object[]) arg;
			for (Object obj : argArray) {
				try {
					if (obj instanceof String) {
						uriList.add(Uri.parse((String) obj));
					} else if (obj instanceof TiFileProxy) {
						uriList.add(Uri.parse(((TiFileProxy) obj).getNativePath()));
					}
				} catch (Exception e) {
					Log.w(NfcConstants.LCAT, "Unable to convert " + obj + " to Uri");
				}
			}
		}
		return ((uriList.size() > 0) ? uriList.toArray(new Uri[uriList.size()]) : null);
	}

	// ---------------------------------------------------------------------------
	// Methods required to run on API thread
	// ---------------------------------------------------------------------------

	@Kroll.method
	public void disableForegroundDispatch()
	{
		// This function must be run on the main UI thread
		if (TiApplication.isUIThread()) {
			handleDisableForegroundDispatch();
		} else {
			TiMessenger.sendBlockingMainMessage(getMainHandler().obtainMessage(MSG_DISABLE_FOREGROUND_DISPATCH));
		}
	}

	@Kroll.method
	public void enableForegroundDispatch(NfcForegroundDispatchFilter filter)
	{
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

	@Override
	public boolean handleMessage(Message msg)
	{
		switch (msg.what) {
			case MSG_DISABLE_FOREGROUND_DISPATCH: {
				AsyncResult result = (AsyncResult) msg.obj;
				try {
					handleDisableForegroundDispatch();
					result.setResult(null);
				} catch (Exception e) {
					result.setResult(e);
				}
				return true;
			}
			case MSG_ENABLE_FOREGROUND_DISPATCH: {
				AsyncResult result = (AsyncResult) msg.obj;
				try {
					handleEnableForegroundDispatch((NfcForegroundDispatchFilter) result.getArg());
					result.setResult(null);
				} catch (Exception e) {
					result.setResult(e);
				}
				return true;
			}
		}
		return super.handleMessage(msg);
	}

	private void handleDisableForegroundDispatch()
	{
		_adapter.disableForegroundDispatch(TiApplication.getAppCurrentActivity());
	}

	private void handleEnableForegroundDispatch(NfcForegroundDispatchFilter filter)
	{
		if (filter != null) {
			_adapter.enableForegroundDispatch(TiApplication.getAppCurrentActivity(), filter.getPendingIntent(),
											  filter.getIntentFilters(), filter.getTechLists());
		}
	}
}
