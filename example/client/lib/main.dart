import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel_connect/web_socket_channel_connect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Example',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController(
    text: 'ws://localhost:5333',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    try {
      final ws = await connectWebSocket(Uri.parse(_controller.text));

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _WebSocketPage(socket: ws),
        ),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
          content: const Text('Unable to connect'),
          title: const Text('Error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(label: Text('URL')),
                onFieldSubmitted: (_) => _connect(),
              ),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: _connect,
              child: const Text('CONNECT'),
            ),
            const SizedBox(width: 16.0),
          ],
        ),
      ),
    );
  }
}

class _WebSocketPage extends StatefulWidget {
  _WebSocketPage({
    required this.socket,
  });

  final WebSocketChannel socket;

  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<_WebSocketPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();

    widget.socket.stream.listen((message) {
      _logs.insert(0, message);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    widget.socket.sink.add(_controller.text);
    _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        try {
          await widget.socket.sink.close();
        } catch (e) {
          // no-op
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Connected')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  label: Text('Message'),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    child: const Text('SEND'),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => Text(_logs[index]),
                  itemCount: _logs.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
