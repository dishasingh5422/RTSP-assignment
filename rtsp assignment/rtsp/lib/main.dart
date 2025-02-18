import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:logging/logging.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RTSP Streaming App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 178, 150, 227)),
      ),
      home: const MyHomePage(title: 'RTSP Streaming App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _urlController = TextEditingController();
  late final VlcPlayerController _vlcPlayerController;
  bool _isLoading = false;
  bool _isValidUrl = true;
  final Logger _logger = Logger('MyHomePage');
  Color _appBarColor = const Color.fromARGB(255, 184, 120, 177);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _vlcPlayerController = VlcPlayerController.network(
      '',
      autoPlay: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _appBarColor = _appBarColor == Colors.blue ? Colors.purple : Colors.blue;
      });
    });
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _initializePlayer(String url) {
    _logger.info('Initializing player with URL: $url');
    if (Uri.tryParse(url)?.hasAbsolutePath != true) {
      setState(() {
        _isValidUrl = false;
      });
      _logger.warning('Invalid URL');
      return;
    }

    setState(() {
      _isLoading = true;
      _isValidUrl = true;
    });

    _vlcPlayerController.dispose();
    _vlcPlayerController = VlcPlayerController.network(
      url,
      autoPlay: true,
    );

    _vlcPlayerController.initialize().then((_) {
      setState(() {
        _isLoading = false;
      });
      _logger.info('Video player initialized');
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      _logger.severe('Error initializing video player: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.title),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter RTSP URL',
                border: OutlineInputBorder(),
                errorText: _isValidUrl ? null : 'Invalid RTSP URL',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _initializePlayer(_urlController.text);
                        },
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Play'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _vlcPlayerController.pause();
                        },
                  child: const Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _vlcPlayerController.stop();
                          setState(() {
                            _vlcPlayerController.dispose();
                          });
                        },
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _vlcPlayerController.value.isInitialized
                ? Expanded(
                    child: VlcPlayer(
                      controller: _vlcPlayerController,
                      aspectRatio: 16 / 9,
                      placeholder: const Center(child: CircularProgressIndicator()),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}