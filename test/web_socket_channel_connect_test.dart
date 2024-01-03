// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:web_socket_channel_connect/web_socket_channel_connect.dart';

void main() {
  test('error', () async {
    try {
      await connectWebSocket(Uri.parse('ws://localhost:5333'));
      fail('Error expected');
    } catch (e) {
      // pass
    }
  });

  test('success', () async {
    final server = await HttpServer.bind('localhost', 5333);
    final completer = Completer();

    // ignore: unawaited_futures
    server.first.then((req) async {
      final socket = await WebSocketTransformer.upgrade(req);
      final message = await socket.first;

      // ignore: avoid_print
      print('[server]: $message');

      socket.add('World');

      await socket.close();
    }).onError((error, stackTrace) async {
      completer.completeError(error ?? 'Error', stackTrace);
    });

    final ws = await connectWebSocket(Uri.parse('ws://localhost:5333'));
    ws.stream.listen((message) {
      // ignore: avoid_print
      print('[client]: $message');

      completer.complete();
    });
    ws.sink.add('Hello');

    await completer.future;
  });
}
