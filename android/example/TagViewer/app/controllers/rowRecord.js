var args = arguments[0] || {};

$.recordType.text = args.record.recordType;
$.tagData.value = JSON.stringify(args.record, function(key, value) {
    if(key === 'source') {
       	return undefined;
    } else {
       	return value;
    }
}, 2);