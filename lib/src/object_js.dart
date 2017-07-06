@JS()
library object_js;

import 'dart:convert';
import 'package:js/js.dart';

@JS('Object')
class JsObject {
  static Object create() => _create(null);

  @JS('create')
  external static Object _create(Object proto);

  external static void defineProperty(
      Object self, String key, _PropertyDescriptor value);

  external static List<String> getOwnPropertyNames(Object self);

  external static bool hasOwnProperty(Object self, String key);

  static Object getPropertyValue(Object self, String key) =>
      _getOwnPropertyDescriptor(self, key)?.value;

  @JS('getOwnPropertyDescriptor')
  external static _PropertyDescriptor _getOwnPropertyDescriptor(
      Object o, String prop);
}

@JS('JSON.stringify')
external String _jsonStringify(Object self);

@JS()
@anonymous
class _PropertyDescriptor {
  external factory _PropertyDescriptor(
      {bool enumerable: false,
      bool configurable: false,
      bool writable: false,
      Object value});

  external bool get enumerable;
  external bool get configurable;
  external bool get writable;
  external Object get value;

}

class JsMap {
  JsMap.fromJsObject(this._value);

  JsMap.fromMap([Map<String, Object> pairs]) {
    this._value = JsObject.create();
    if (pairs != null) {
      for (final key in pairs.keys) {
        this[key] = pairs[key];
      }
    }
  }

  Object _value;
  Object get value => _value;

  List<String> get keys => JsObject.getOwnPropertyNames(_value);

  Object operator [](String key) {
    if (JsObject.hasOwnProperty(_value, key)) {
      return JsObject.getPropertyValue(_value, key);
    }
    return null;
  }

  void operator []=(String key, Object value) {
    JsObject.defineProperty(
        _value, key, new _PropertyDescriptor(value: value, enumerable: true));
  }

  @override
  String toString() {
    final json = _jsonStringify(_value);
    return '${JSON.decode(json)}';
  }
}
