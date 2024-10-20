import 'dart:convert';

dynamic jsonSafeDecode(String source) {
  //? sometimes, jsonDecode doesn't decode to json and causes an error
  var decoded = jsonDecode(source);
  if (decoded is String) {
    decoded = jsonDecode(decoded);
  }
  return decoded;
}
