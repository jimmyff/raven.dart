@TestOn('browser')
library raven_test;

import 'dart:math' as math;
import 'package:http/browser_client.dart';
import 'package:raven/raven.dart';
import 'package:raven/src/api/api.dart';
import 'package:test/test.dart';
import 'api_key.dart';

void main() {
  group('raven_test', () {
    RavenApi api;
    String testId;
    setUp(() {
      api = new RavenApi(
          apiKey, organization, angularProject, new BrowserClient());
      testId = new math.Random().nextInt(10000).toString();
    });

    tearDown(() {});

    test('script delayed loading', () async {
      // set up

// exercise

      final tags = new JsMapRef.fromMap({'test_id': testId});
      Raven.doBufferExceptions = true;
      Raven.captureException('1');
      Raven.captureException('2');
      Raven.captureException('3');
      await RavenScriptLoader.loadScript();
      Raven.config(dsn);
      Raven.install();
      Raven.sendBufferedExceptions();

      // verification
      final events = await api.projectEvents();
      print('x');

      // tear down
    });

    test('basic', () async {
      // set up
      Raven.config(dsn);
      Raven.user = new User(
          id: 'user id',
          name: 'user name',
          ipAddress: '195.96.0.1',
          email: 'john@example.com');
      Raven.install();
      final tags = new JsMapRef.fromMap({'tag1': 'tagValue1'});
      print('tags: $tags');
      Raven.tags = tags;

      try {
        throw new Exception(new DateTime.now().toIso8601String());
      } catch (error) {
        Raven.captureException(error);
      }
      print('lastException: ${Raven.lastException}');
      print('lastException: ${Raven.lastEventId}');
      Raven.context.toString();
      print('context: ${Raven.context.toString()}');

      //      Raven.showReportDialog();
      // exercise
      // verification
      expect('', equals(''));
      // tear down
    });
  });
}
