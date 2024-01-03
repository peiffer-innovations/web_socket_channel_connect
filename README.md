**DEPRECATED**: This package is deprecated and no longer necessary since [web_socket_channel](https://pub.dev/packages/web_socket_channel) version `2.3.0`.


## Old method

```dart
import 'package:web_socket_channel_connect/web_socket_channel_connect.dart';

Future<void> main() async {
  final channel = connectWebSocket(Uri.parse('ws:localhost:5333'));

  channel.stream.listen((message) {});
}
```

## New method

```dart
import 'package:web_socket_channel/web_socket_channel.dart';

main() async {
  final wsUrl = Uri.parse('ws:localhost:5333');
  final channel = WebSocketChannel.connect(wsUrl);

  await channel.ready;

  channel.stream.listen((message) {});
}```
