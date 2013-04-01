/**
 * Appcelerator NFC module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.nfc;

import java.util.ArrayList;
import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.proxy.IntentProxy;
import org.appcelerator.titanium.util.TiConvert;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.IntentFilter.MalformedMimeTypeException;
import android.util.Log;

@Kroll.proxy(creatableInModule = NfcModule.class, propertyAccessors = {
	NfcConstants.PROPERTY_INTENT, 
	NfcConstants.PROPERTY_INTENT_FILTERS,
	NfcConstants.PROPERTY_TECH_LISTS
})
public class NfcForegroundDispatchFilter extends KrollProxy
{
	private PendingIntent _pendingIntent = null;
	private Intent _intent = null;
	private IntentFilter[] _intentFilters = null;
	private String[][] _techLists = null;
	
	public NfcForegroundDispatchFilter() {
		super();
	}
	
	@Override
	public void handleCreationArgs(KrollModule createdInModule, Object[] args) {
		// Call the superclass method -- this will result in a call to handleCreationDict
		super.handleCreationArgs(createdInModule, args);
		createPendingIntent();
	}
	
	@Override
	public void handleCreationDict(KrollDict kd) {
		if (kd.containsKey(NfcConstants.PROPERTY_INTENT)) {
			parseIntent(kd.get(NfcConstants.PROPERTY_INTENT));
		}
		if (kd.containsKey(NfcConstants.PROPERTY_INTENT_FILTERS)) {
			parseIntentFilters(kd.get(NfcConstants.PROPERTY_INTENT_FILTERS));
		}
		if (kd.containsKey(NfcConstants.PROPERTY_TECH_LISTS)) {
			parseTechLists(kd.get(NfcConstants.PROPERTY_TECH_LISTS));
		}
		
		super.handleCreationDict(kd);
	}
	
	public PendingIntent getPendingIntent() {
		return _pendingIntent;
	}
	
	public IntentFilter[] getIntentFilters() {
		return _intentFilters;
	}
	
	public String[][] getTechLists() {
		return _techLists;
	}
	
	private void createPendingIntent() {
		Activity activity = TiApplication.getAppCurrentActivity();
		// If an intent was not specified, then create a default one
		if (_intent == null) {
			_intent = new Intent(activity, activity.getClass());
			_intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		}
		
		_pendingIntent = PendingIntent.getActivity(activity, 0, _intent, 0);		
	}
	
	private void parseIntent(Object prop) {
		if (prop instanceof IntentProxy) {
			IntentProxy proxy = (IntentProxy)prop;
			_intent = proxy.getIntent();
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void parseIntentFilters(Object prop) {
		ArrayList<IntentFilter> intentFilters = new ArrayList<IntentFilter>();
		if (prop instanceof Object[]) {
			Object[] filterArray = (Object[])prop;
			for (Object entry : filterArray) {
				if (entry instanceof HashMap) {
					KrollDict kd = new KrollDict((HashMap)entry);
					
					// Create the intent filter from the specified action
					String action = kd.getString(NfcConstants.PROPERTY_ACTION);
					IntentFilter intentFilter = new IntentFilter(action);
					
					// Support for "mimeType"
					if (kd.containsKey(NfcConstants.PROPERTY_MIME_TYPE)) {
						try {
							intentFilter.addDataType(kd.getString(NfcConstants.PROPERTY_MIME_TYPE));
						} catch (MalformedMimeTypeException e) {
							Log.e(NfcConstants.LCAT, "Malformed Mime Type Exception", e);
						}
					}
					
					// Support for "sheme" and "host"
					if (kd.containsKey(NfcConstants.PROPERTY_SCHEME)) {
						intentFilter.addDataScheme(kd.getString(NfcConstants.PROPERTY_SCHEME));
					}
					if (kd.containsKey(NfcConstants.PROPERTY_HOST)) {
						intentFilter.addDataAuthority(kd.getString(NfcConstants.PROPERTY_HOST), null);
					}
					
					intentFilters.add(intentFilter);
				}
			}
		}
		if (intentFilters.size() > 0) {
			_intentFilters = intentFilters.toArray(new IntentFilter[intentFilters.size()]);
		}
	}
	
	public void parseTechLists(Object prop) {
		ArrayList<String[]> techLists = new ArrayList<String[]>();
		if (prop instanceof Object[]) {
			for (Object entry : (Object[])prop) {
				if (entry instanceof Object[]) {
					techLists.add(TiConvert.toStringArray((Object[])entry));
				}
			}
		}
		if (techLists.size() > 0) {
			_techLists = techLists.toArray(new String[techLists.size()][]);
		} 
	}
}
