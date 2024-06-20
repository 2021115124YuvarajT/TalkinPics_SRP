import 'dart:async';
import 'dart:core';
import 'package:aac_srp/screens/Language.dart';
import 'package:flutter/material.dart';

import 'package:aac_srp/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static String id = 'settings_screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Timer _timer;
  List<Color> _buttonColors = [
    Colors.yellowAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.brown.shade100,
    Colors.brown.shade100,
  ];

  List<bool> _highlightedButtons = List.filled(7, false); // Updated

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
        for (int i = 0; i < _highlightedButtons.length; i++) {
          _highlightedButtons[i] = i == timerCount % 7;
        }
        timerCount++;
      });
    });
  }

  void updateColor(int ind, Color newcolor) {
    _buttonColors[ind] = newcolor;
  }

  void _handleButtonClick(int index) {
    switch (index) {
      case 0:
        _setTimerDuration(2);
        updateColor(0, Colors.red);
        updateColor(1, Colors.yellowAccent.shade100);
        break;
      case 1:
        _setTimerDuration(4);
        updateColor(0, Colors.yellowAccent.shade100);
        updateColor(1, Colors.red);
        break;
      case 2:
        selectedIconCount = 4;
        updateColor(3, Colors.greenAccent.shade100);
        updateColor(2, Colors.red);
        updateColor(4, Colors.greenAccent.shade100);
        break;
      case 3:
        selectedIconCount = 9;
        updateColor(2, Colors.greenAccent.shade100);
        updateColor(3, Colors.red);
        updateColor(4, Colors.greenAccent.shade100);
        break;
      case 4:
        selectedIconCount = 16;
        updateColor(2, Colors.greenAccent.shade100);
        updateColor(3, Colors.greenAccent.shade100);
        updateColor(4, Colors.red);
        break;
      case 5:
        Navigator.pushNamed(context, LanguagePage.id, arguments: timerDuration);
        break;
      case 6:
        Navigator.pop(context);
    }
  }

  void _setTimerDuration(int duration) {
    setState(() {
      timerDuration = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2196F3),
          title: Text('AAC APP'),
        ),
        body: GestureDetector(
          onTap: () {
            int highlightedIndex = _highlightedButtons.indexOf(true);
            if (highlightedIndex != -1) {
              _handleButtonClick(highlightedIndex);
            }
          },
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
                  for (int i = 0; i < 7; i++)
                    ElevatedButton(
                      onPressed: () => _handleButtonClick(i),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonColors[i],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: _highlightedButtons[i]
                                ? Colors.red
                                : Colors.black,
                            width: _highlightedButtons[i] ? 10 : 2,
                            style: _highlightedButtons[i]
                                ? BorderStyle.solid
                                : BorderStyle.solid,
                          ),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        i == 0
                            ? '2 seconds'
                            : i == 1
                                ? '4 seconds'
                                : i == 2
                                    ? '4 icons'
                                    : i == 3
                                        ? '9 icons'
                                        : i == 4
                                            ? '16 icons'
                                            : i == 5
                                                ? 'Language'
                                                : 'Back',
                        style: TextStyle(color: Colors.black, fontSize: 18),
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
