// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() => runApp(TextToSpeechApp());

// class TextToSpeechApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TextToSpeechScreen(),
//       theme: ThemeData.dark().copyWith(
//         primaryColor: Colors.green,
//         scaffoldBackgroundColor: Colors.black,
//       ),
//     );
//   }
// }

// class TextToSpeechScreen extends StatefulWidget {
//   @override
//   _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
// }

// class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
//   final FlutterTts flutterTts = FlutterTts();
//   final TextEditingController _controller = TextEditingController();

//   double _pitch = 1.0;
//   double _speechRate = 0.5;
//   String _language = 'en-US';

//   @override
//   void initState() {
//     super.initState();
//     _initializeTTS();
//     _requestPermissions();
//   }

//   void _initializeTTS() {
//     flutterTts.setLanguage(_language);
//     flutterTts.setPitch(_pitch);
//     flutterTts.setSpeechRate(_speechRate);
//   }

//   Future<void> _requestPermissions() async {
//     if (await Permission.storage.request().isDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Storage permission is required to download audio.')),
//       );
//     }
//   }

//   Future<void> _speak() async {
//     if (_controller.text.isNotEmpty) {
//       await flutterTts.speak(_controller.text);
//     }
//   }

//   Future<void> _stop() async {
//     await flutterTts.stop();
//   }

//   Future<void> _downloadAudio() async {
//     if (_controller.text.isNotEmpty) {
//       try {
//         final String filePath = '/storage/emulated/0/Download/speech_audio.mp3';
//         await flutterTts.synthesizeToFile(_controller.text, filePath);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Audio saved to $filePath')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save audio: $e')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter some text to download.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enhanced Text-to-Speech'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Enter text',
//                 ),
//                 maxLines: 4,
//               ),
//               SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _speak,
//                       child: Text('Speak'),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _stop,
//                       child: Text('Stop'),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _downloadAudio,
//                 child: Text('Download Audio'),
//               ),
//               SizedBox(height: 16),
//               Text('Pitch: ${_pitch.toStringAsFixed(1)}'),
//               Slider(
//                 value: _pitch,
//                 min: 0.5,
//                 max: 2.0,
//                 divisions: 15,
//                 label: _pitch.toStringAsFixed(1),
//                 onChanged: (value) {
//                   setState(() {
//                     _pitch = value;
//                     flutterTts.setPitch(_pitch);
//                   });
//                 },
//               ),
//               Text('Speech Rate: ${_speechRate.toStringAsFixed(1)}'),
//               Slider(
//                 value: _speechRate,
//                 min: 0.1,
//                 max: 1.0,
//                 divisions: 10,
//                 label: _speechRate.toStringAsFixed(1),
//                 onChanged: (value) {
//                   setState(() {
//                     _speechRate = value;
//                     flutterTts.setSpeechRate(_speechRate);
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(TextToSpeechApp());

class TextToSpeechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextToSpeechScreen(),
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

class TextToSpeechScreen extends StatefulWidget {
  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _controller = TextEditingController();

  double _pitch = 1.0;
  double _speechRate = 0.5;
  String _language = 'en-US';

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _requestPermissions();
  }

  void _initializeTTS() {
    flutterTts.setLanguage(_language);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Text-to-Speech',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Section
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Text",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            // Control Buttons
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
            // Pitch Slider
            Text(
              "Pitch: ${_pitch.toStringAsFixed(1)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
            // Speech Rate Slider
            Text(
              "Speech Rate: ${_speechRate.toStringAsFixed(1)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
      ),
    );
  }
}
