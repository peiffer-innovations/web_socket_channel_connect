// ignore_for_file: avoid_print

import 'dart:io';

Future<void> main() async {
  final ips = await NetworkInterface.list();
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 5333);
  print('Listening on: ${ips.first}:5333...');

  await for (var req in server) {
    final socket = await WebSocketTransformer.upgrade(req);

    socket.listen((message) {
      print('[server]: $message');

      socket.add(message);
    });

    // ignore: unawaited_futures
    socket.done.then((value) => socket.close());
  }
}
