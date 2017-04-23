# raven

A library for Dart developers. It is awesome.

## Test API from command line

```bash
request=$(curl -H "Authorization: Bearer 83e9c8e3822644d48f1f390fd78c050a0dd695775be248098424f53815cc9592" https://sentry.io/api/0/projects/rocketware/datingnode-app-angular/events/)
echo $request
```

## Usage

A simple usage example:

    import 'package:raven/raven.dart';

    main() {
      var awesome = new Awesome();
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme


