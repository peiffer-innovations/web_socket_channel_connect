import 'dart:async';
import 'dart:html';

import 'package:web_socket_channel/html.dart';
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
  final ws = WebSocket(uri.toString(), protocols);

  Completer? completer = Completer();
  final future = completer.future;

  ws.onClose.listen((_) {
    completer?.completeError('Closed');
    completer = null;
  });

  ws.onError.listen((event) {
    completer?.completeError('Error: $event');
    completer = null;
  });

  ws.onOpen.listen((_) {
    completer?.complete();
    completer = null;
  });

  await future;

  return HtmlWebSocketChannel(ws);
}
