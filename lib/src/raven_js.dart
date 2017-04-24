@JS()
library raven_js;

import 'package:js/js.dart';
import 'package:logging/logging.dart';
import 'package:raven/raven.dart';
import 'package:raven/src/object_js.dart';

class Raven {
  static bool get debug => _Raven.debug;

  static set debug(bool value) {
    _Raven.debug = value;
  }

  static void config(String url, [GlobalOptions options]) {
    _Raven.config(url, options);
  }

  static void install() {
    _Raven.install();
  }

  static set dsn(String dsn) {
    _Raven.setDSN(dsn);
  }

  static void setContext(
          GlobalOptions options, Function func, List<Object> args) =>
      _Raven.context(options, allowInteropCaptureThis(func), args);

  static void uninstall() {
    _Raven.uninstall();
  }

  static final _buffer = <List>[];
  static bool doBufferExceptions = false;

  static void sendBufferedExceptions() {
    for (final e in _buffer) {
      _Raven.captureException(e[0], e[1] as Options);
    }
    _buffer.clear();
    doBufferExceptions = false;
  }

  static void captureException(Object exception, [Options options]) {
    if (doBufferExceptions) {
      _buffer.add(<dynamic>[exception, options]);
    } else {
      _Raven.captureException(exception, options);
    }
  }

  static void captureMessage(String message, [Options options]) {
    _Raven.captureMessage(message, options);
  }

  static void captureBreadcrumb(Map<String, Object> breadcrumb) {
    _Raven.captureBreadcrumb(breadcrumb);
  }

  static set user(User context) {
    _Raven.setUserContext(context);
  }

  static set extra(Map<String, Object> extra) {
    _Raven.setExtraContext(extra);
  }

  static set tags(JsMap tags) {
    _Raven.setTagsContext(tags.value);
  }

  static void clearContext() {
    _Raven.clearContext();
  }

  static Context get context => new Context.fromJsObject(_Raven.getContext());

  static set environment(String environment) {
    _Raven.setEnvironment(environment);
  }

  static set release(String release) {
    _Raven.setRelease(release);
  }

  static Map<String, Object> get lastException => _Raven.lastException();

  static String get lastEventId => _Raven.lastEventId();

  static bool get isSetup => _Raven.isSetup();

  static void showReportDialog() {
    _Raven.showReportDialog();
  }
}

@JS('Raven')
class _Raven {
  external static bool get debug;
  external static set debug(bool value);

  external static void config(String url, [GlobalOptions options]);

  external static void install();

  external static void setDSN(String dsn);

  external static void context(Object options, Function func, Object args);

  // TODO(zoechi) wrap: function(options, func, _before) {

  external static void uninstall();

  external static void captureException(Object exception, [Options options]);

  external static void captureMessage(String message, [Options options]);

  external static void captureBreadcrumb(Object obj);

  external static void setUserContext(User context);

  external static void setExtraContext(Map<String, Object> extra);

  external static void setTagsContext(Object tags);

  external static void clearContext();

  external static Context getContext();

  external static void setEnvironment(String environment);

  external static void setRelease(String release);

  // TODO(zoechi) setDataCallback: function(callback) {

  // TODO(zoechi) setBreadcrumbCallback: function(callback) {

  // TODO(zoechi) setShouldSendCallback: function(callback) {

  // TODO(zoechi) setTransport: function(transport) {

  // TODO(zoechi) seems not to work
  external static Map<String, Object> lastException();

  external static String lastEventId();

  external static bool isSetup();

  external static void showReportDialog();
}

@JS()
@anonymous
class Context extends JsMap {
  external User get user;
  JsMap get tags => new JsMap.fromJsObject(_tags);

  @JS('tags')
  external Object get _tags;

  Context.fromJsObject(Object obj) : super.fromJsObject(obj);
}

@JS()
@anonymous
class Breadcrumb {}

@JS()
@anonymous
class User {
  external String get id;
  external set id(String value);

  external String get name;
  external set name(String value);

  external String get ipAddress;
  external set ipAddress(String value);

  external String get email;
  external set email(String value);

  external factory User(
      {String id, String name, String ipAddress, String email});

  @override
  bool operator ==(Object o) => identical(this, o) || (o is User && id != o.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      "UserInterface{id='$id', username='$name', ipAddress='$ipAddress', "
      "email='$email'}";
}

@JS()
@anonymous
class Options {
  String logger;
  String level;
  String timestamp;
  // not sure this becomes available at sentry.io
  Object extra;
  external factory Options({
    String logger,
    String level,
    String timestamp,
    JsMap extra,
  });
}

@JS()
@anonymous
class GlobalOptions {
  external String get logger;
  external List<String> get ignoreErrors;
  external List<String> get ignoreUrls;
  external List<String> get whitelistUrls;
  external List<String> get includePaths;
  external String get crossOrigin;
  external bool get collectWindowErrors;
  external int get maxMessageLength;

  // By default, truncates URL values to 250 chars
  int maxUrlLength;
  int stackTraceLimit;

  /// `bool` or [AutoBreadcrumbOptions]
  Object autoBreadcrumbs;
  int sampleRate;

  external factory GlobalOptions(
      {String logger,
      List<String> ignoreErrors,
      List<String> ignoreUrls,
      List<String> whitelistUrls,
      List<String> includePaths,
      String crossOrigin,
      bool collectWindowErrors,
      num maxMessageLength,
      num maxUrlLength,
      num stackTraceLimit,
      Object autoBreadcrumbs,
      num sampleRate});
}

@JS()
@anonymous
class AutoBreadcrumbOptions {
  external bool get xhr;
  external bool get console;
  external bool get dom;
  external bool get location;
  AutoBreadcrumbOptions(
      {bool xhr: true,
      bool console: true,
      bool dom: true,
      bool location: true});
}

/// Levels of log available in Sentry.
class EventLevel {
  /// Debug information to track every detail of the application execution process.
  static const EventLevel debug = const EventLevel("debug", Level.FINE);

  /// Info is used to give general details on the running application, usually only messages.
  static const EventLevel info = const EventLevel("info", Level.INFO);

  /// Warning should be used to define logs generated by expected and handled bad behaviour.
  static const EventLevel warning = const EventLevel("warning", Level.WARNING);

  /// Error denotes an unexpected behaviour that prevented the code to work properly.
  static const EventLevel error = const EventLevel("error", Level.SEVERE);

  /// Fatal is the highest form of log available, use it for unrecoverable issues.
  static const EventLevel fatal = const EventLevel("fatal", Level.SHOUT);

  final String value;
  final Level logLevel;

  const EventLevel(this.value, this.logLevel);

  static EventLevel fromLogLevel(Level level) {
    if (level < debug.logLevel) {
      return null;
    } else if (level < info.logLevel) {
      return debug;
    } else if (level < warning.logLevel) {
      return info;
    } else if (level < error.logLevel) {
      return warning;
    } else if (level < fatal.logLevel) {
      return error;
    } else {
      return fatal;
    }
  }
}
