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
              child: Text('CLOSE'),
            ),
          ],
          content: Text('Unable to connect'),
          title: Text('Error'),
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
            SizedBox(width: 16.0),
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(label: Text('URL')),
                onFieldSubmitted: (_) => _connect(),
              ),
            ),
            SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: _connect,
              child: Text('CONNECT'),
            ),
            SizedBox(width: 16.0),
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
        appBar: AppBar(title: Text('Connected')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  label: Text('Message'),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    child: Text('SEND'),
                  ),
                ],
              ),
              Divider(),
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
