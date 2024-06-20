import 'dart:async';

import 'package:aac_srp/screens/about.dart';
import 'package:aac_srp/screens/category_selection.dart';
import 'package:aac_srp/screens/xylophone.dart';
import 'package:flutter/material.dart';

import 'Settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = 'home_screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  List<Color> _buttonColors = [
    Colors.yellowAccent.shade100,
    Colors.blueAccent,
    Colors.greenAccent,
  ];
  List<bool> _highlightedButtons = List.filled(3, false); // Updated
  int _timerDuration = 0; // Variable to hold the selected timer duration

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
          _highlightedButtons[i] = i == timerCount % 3;
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
        Navigator.pushNamed(context, CategorySelection.id,
            arguments: _timerDuration);
        break;
      case 1:
        Navigator.pushNamed(context, XylophonePage.id,
            arguments: _timerDuration);
        break;
      case 2:
        Navigator.pushNamed(context, SettingsScreen.id,
            arguments: _timerDuration); // Pass timer duration as argument
        break;
    }
  }

  void _setTimerDuration(int duration) {
    setState(() {
      _timerDuration = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2196F3),
          title: Text('TalkinPics'),
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
                  for (int i = 0; i < 3; i++)
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
                                : Colors.transparent,
                            width: _highlightedButtons[i] ? 10 : 2,
                            style: _highlightedButtons[i]
                                ? BorderStyle.solid
                                : BorderStyle.none,
                          ),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        i == 0
                            ? 'Picture Communication'
                            : i == 1
                                ? 'Xylophone'
                                : 'Settings',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10.0),
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () {
              Navigator.pushNamed(context, AboutUs.id);
            }, // Open the AboutUs page
            child: Text('About Us'),
          ),
        ),
      ),
    );
  }
}
