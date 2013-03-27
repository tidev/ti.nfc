var args = arguments[0] || {};

$.tagId.text = args.tag.id;
$.techList.text = args.tag.techList.join("\n").replace(/android.nfc.tech./g, '');

