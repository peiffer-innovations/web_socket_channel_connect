import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

@Deprecated('''
This is no longer necessary as of 2.3.0 of the web_socket_channel package.  To
update your code from this package to the direct web_socket_channel one simply
change from:

  final ws = await connectWebSocket(uri)

to:

  final ws = WebSocketChannel.connect(
    uri,
    protocols: protocols,
  );

  await ws.ready;
```
''')
Future<WebSocketChannel> connectWebSocket(
  Uri uri, {
  Duration? connectionTimeout,
  Map<String, dynamic>? headers,
  Function(EventSink<dynamic>)? onTimeout,
  Duration? pingInterval,
  Iterable<String>? protocols,
}) async {
  final channel = WebSocketChannel.connect(
    uri,
    protocols: protocols,
  );

  await channel.ready;

  return channel;
}
