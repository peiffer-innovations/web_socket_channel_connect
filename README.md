# web_socket_channel_connect

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

A small wrapper for the [web_socket_channel](https://pub.dev/packages/web_socket_channel) package that throws a synchronous error if the connection fails.

This addresses the following open issues on the [web_socket_channel](https://pub.dev/packages/web_socket_channel) package:
* https://github.com/dart-lang/web_socket_channel/issues/226
* https://github.com/dart-lang/web_socket_channel/issues/220
* https://github.com/dart-lang/web_socket_channel/issues/214
* https://github.com/dart-lang/web_socket_channel/issues/209


## Usage

```dart
import 'package:web_socket_channel_connect/web_socket_channel_connect.dart';

Future<void> main() async {
  final channel = connectWebSocket(Uri.parse('ws:localhost:5333'));

  channel.stream.listen((message) {});
}
```