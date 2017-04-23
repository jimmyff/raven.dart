@TestOn('vm')
library raven.test.api;

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:raven/src/api/api.dart';
import '../api_key.dart';

void main() {
  group('raven.test.api', () {
    RavenApi api;
    setUp(() {
      api = new RavenApi(apiKey, organization, angularProject, new IOClient());
    });

    tearDown(() {});

    test('basic', () async {
      // set up
      // exercise
      final result = await api.projectEvents();
      // verification
      expect(result, isList);
      // tear down
    });
  });
}
