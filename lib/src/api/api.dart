import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'package:http/http.dart' show BaseClient;

class RequestType {
  static const RequestType projectEvents =
      const RequestType('projects', 'events');
  final String scope;
  final String name;

  const RequestType(this.scope, this.name);
}

class RavenApi {
  final BaseClient httpClient;
  final String host;
  final String organizationSlug;
  final String projectSlug;
  final Map<String, String> _headers;

  RavenApi(String key, this.organizationSlug, this.projectSlug, this.httpClient,
      {this.host: 'https://sentry.io'})
      : _headers = <String, String>{'Authorization': 'Bearer $key'};

  Uri requestUri(RequestType type) => Uri.parse(
      '$host/api/0/${type.scope}/$organizationSlug/$projectSlug/${type.name}/');

  Future<List<dynamic>> projectEvents() async {
    final response = await httpClient.get(requestUri(RequestType.projectEvents),
        headers: _headers);
    return JSON.decode(response.body) as List;
  }
}
