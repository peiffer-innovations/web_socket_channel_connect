import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connect(
  Uri uri, {
  Duration? connectionTimeout,
  Map<String, dynamic>? headers,
  Function(EventSink<dynamic>)? onTimeout,
  Duration? pingInterval,
  Iterable<String>? protocols,
}) async =>
    throw UnimplementedError(
      "This shouldn't happen, either html or io should have been called.",
    );
