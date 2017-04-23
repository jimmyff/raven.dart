import 'dart:async' show Completer, Future;
import 'dart:html' show document, ScriptElement;

class RavenScriptLoader {
  static const String defaultRavenScriptUrl =
      'https://cdn.ravenjs.com/3.14.2/raven.min.js';
  static const String scriptTagAttribute = 'ravenfromdart';

  static final _scriptLoadedCompleter = new Completer<bool>();
  static Future get onScriptLoaded => _scriptLoadedCompleter.future;

  static bool _isScriptLoaded = false;
  static bool get isScriptLoaded => _isScriptLoaded;

  /// Load the Raven JS script.
  /// The returned [Future] completes when the script tag is done loading.
  /// Subsequent calls don't have any effect. The script tag will only be loaded
  /// once.
  /// [src] and [type] allow to pass custom values.
  static Future loadScript(
      {String src: defaultRavenScriptUrl,
      String type: 'application/javascript',
      bool defer: true}) async {
    var script =
        document.querySelector('script[$scriptTagAttribute]') as ScriptElement;

    if (script == null) {
      script = new ScriptElement()
        ..type = 'text/javascript'
        ..attributes['src'] = src
        ..attributes[scriptTagAttribute] = 'true'
        ..onLoad.listen((_) {
          _isScriptLoaded = true;
          _scriptLoadedCompleter.complete();
        })
        ..onError.listen(_scriptLoadedCompleter.completeError);
      if (defer) {
        script.attributes['defer'] = 'true';
      }
      document.head.append(script);
    }
    return _scriptLoadedCompleter.future;
  }
}
