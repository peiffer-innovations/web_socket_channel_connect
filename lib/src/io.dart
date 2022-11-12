import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connect(
  Uri uri, {
  Duration? connectionTimeout,
  Map<String, dynamic>? headers,
  Function(EventSink<dynamic>)? onTimeout,
  Duration? pingInterval,
  Iterable<String>? protocols,
}) async {
  // ignore: close_sinks
  final ws = await WebSocket.connect(
    uri.toString(),
    headers: headers,
    protocols: protocols,
  );

  if (connectionTimeout != null) {
    ws.timeout(
      connectionTimeout,
      onTimeout: onTimeout,
    );
  }

  if (pingInterval != null) {
    ws.pingInterval = pingInterval;
  }

  return IOWebSocketChannel(ws);
}
