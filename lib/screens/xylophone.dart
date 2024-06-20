import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

void player(int soundNumber) {
  final player = AudioPlayer();
  player.play(AssetSource('note$soundNumber.wav'));
}

class XylophonePage extends StatefulWidget {
  static String id = 'xylophone_page';

  @override
  State<XylophonePage> createState() => _XylophonePageState();
}

class _XylophonePageState extends State<XylophonePage> {
  late Timer _timer;
  int _highlightedButtonIndex = 0;
  List<Color> _buttonColors = [
    Colors.red,
    Colors.blue.shade900,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
    Colors.purple,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    _startHighlighting();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startHighlighting() {
    int timerCount = 0;
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _highlightedButtonIndex = timerCount % 8;
        timerCount++;
      });
    });
  }

  void _handleButtonClick(int index) {
    if (index == 7) {
      // If the last button (back button) is clicked, navigate back to the home screen
      Navigator.pop(context);
    } else {
      player(index + 1); // Play the corresponding note
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Trigger action corresponding to the highlighted button
        _handleButtonClick(_highlightedButtonIndex);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Xylophone'),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    './lib/assets/test.jpg'), // Replace 'assets/background_image.jpg' with your image asset path
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < 8; i++)
                    ElevatedButton(
                      onPressed: () => _handleButtonClick(i),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonColors[i],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: _highlightedButtonIndex == i
                                ? Colors.black
                                : Colors.transparent,
                            width: _highlightedButtonIndex == i ? 10 : 2,
                            style: _highlightedButtonIndex == i
                                ? BorderStyle.solid
                                : BorderStyle.none,
                          ),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        i == 7 ? 'Back' : 'Note ${i + 1}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
