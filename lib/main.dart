import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(TextToSpeechApp());

class TextToSpeechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Speech Utilities',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.teal,
            tabs: [
              Tab(text: "Text to Speech", icon: Icon(Icons.volume_up)),
              Tab(text: "Speech to Text", icon: Icon(Icons.mic)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TextToSpeechScreen(),
            SpeechToTextScreen(),
          ],
        ),
      ),
    );
  }
}

// Text to Speech Screen
class TextToSpeechScreen extends StatefulWidget {
  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _controller = TextEditingController();

  double _pitch = 1.0;
  double _speechRate = 0.5;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _requestPermissions();
  }

  void _initializeTTS() {
    flutterTts.setLanguage('en-US');
    flutterTts.setPitch(_pitch);
    flutterTts.setSpeechRate(_speechRate);
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Storage permission is required to download audio.')),
      );
    }
  }

  Future<void> _speak() async {
    if (_controller.text.isNotEmpty) {
      await flutterTts.speak(_controller.text);
    }
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  Future<void> _downloadAudio() async {
    if (_controller.text.isNotEmpty) {
      try {
        final String filePath = '/storage/emulated/0/Download/speech_audio.mp3';
        await flutterTts.synthesizeToFile(_controller.text, filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio saved to $filePath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save audio: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some text to download.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Text",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type here...",
                      border: InputBorder.none,
                    ),
                    maxLines: 4,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _speak,
                  icon: Icon(Icons.volume_up),
                  label: Text('Speak'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _stop,
                  icon: Icon(Icons.stop),
                  label: Text('Stop'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _downloadAudio,
            icon: Icon(Icons.download),
            label: Text('Download Audio'),
          ),
          SizedBox(height: 16),
          Text("Pitch: ${_pitch.toStringAsFixed(1)}",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _pitch,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            label: _pitch.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _pitch = value;
                flutterTts.setPitch(_pitch);
              });
            },
          ),
          Text("Speech Rate: ${_speechRate.toStringAsFixed(1)}",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _speechRate,
            min: 0.1,
            max: 1.0,
            divisions: 10,
            label: _speechRate.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _speechRate = value;
                flutterTts.setSpeechRate(_speechRate);
              });
            },
          ),
        ],
      ),
    );
  }
}

// Speech to Text Screen
class SpeechToTextScreen extends StatefulWidget {
  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _text = "Tap the button and start speaking";

  // Request microphone permission
  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Microphone permission is required for speech recognition.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speech recognition not available.')),
      );
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _text,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isListening ? _stopListening : _startListening,
            icon: Icon(_isListening ? Icons.stop : Icons.mic),
            label: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
          ),
        ],
      ),
    );
  }
}
