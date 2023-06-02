import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterMidi flutterMidi = FlutterMidi();
  String path = 'assets/Best of Guitars-4U-v1.0.sf2';
  late Future<NotePosition> position;

  @override
  void initState() {
    // load('assets/sf2/Piano.SF2');
    load(path);
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    //flutterMidi.prepare(sf2: _byte);
    flutterMidi.prepare(sf2: _byte, name: path.replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              actions: [
                DropdownButton<String>(
                  value: path,
                  onChanged: (String? value) {
                    if (kDebugMode) {
                      print(value);
                    }
                    setState(() {
                      if (value != null) {
                        path = value;
                        load(value);
                      }
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'assets/Yamaha-Grand-Lite-SF-v1.1.sf2',
                      child: Text('piano'),
                    ),
                    DropdownMenuItem(
                      value: 'assets/Best of Guitars-4U-v1.0.sf2',
                      child: Text('guitar'),
                    ),
                    DropdownMenuItem(
                      value: 'assets/Expressive Flute SSO-v1.2.sf2',
                      child: Text('flute'),
                    ),
                  ],
                )
              ],
            ),
            body: CupertinoApp(
                title: 'Piano Demo',
                home: Center(
                  child: InteractivePiano(
                    highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
                    naturalColor: Colors.white,
                    accidentalColor: Colors.black,
                    keyWidth: 60,
                    noteRange: NoteRange.forClefs([
                      Clef.Treble,
                    ]),
                    onNotePositionTapped: (position) {
                      print(position.pitch);
                      flutterMidi.playMidiNote(midi: position.pitch);
                      // Use an audio library like flutter_midi to play the sound
                    },
                  ),
                ))));
  }
}
