import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'src/stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'src/html.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'src/io.dart' as platform;

Future<WebSocketChannel> connectWebSocket(
  Uri uri, {
  Duration? connectionTimeout,
  Map<String, dynamic>? headers,
  Function(EventSink<dynamic>)? onTimeout,
  Duration? pingInterval,
  Iterable<String>? protocols,
}) =>
    platform.connect(
      uri,
      connectionTimeout: connectionTimeout,
      headers: headers,
      onTimeout: onTimeout,
      pingInterval: pingInterval,
      protocols: protocols,
    );
