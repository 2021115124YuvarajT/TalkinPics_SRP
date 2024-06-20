import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../utils/constants.dart';

class LanguagePage extends StatefulWidget {
  static String id = 'language_page';

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late Timer _timer;
  int _highlightedIndex = 0;
  List<Color> clrvalue = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
  ];
  final FlutterTts flutterTts = FlutterTts();
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

  void updateColor(int index, Color value) {
    setState(() {
      clrvalue[index] = value;
    });
  }

  void _startHighlighting() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _highlightedIndex = (_highlightedIndex + 1) % 3;
        // Reset all clrvalue entries to white
      });
    });
  }

  void _handleButtonClick(int index) async {
    // Implement actions based on the highlighted button
    switch (index) {
      case 0:
        // Add your action for English button
        user_language = "en-US";
        language_file = "english";
        updateColor(0, Colors.red);
        updateColor(1, Colors.greenAccent);
        break;
      case 1:
        // Add your action for Tamil button
        List<dynamic>? languages = await flutterTts.getLanguages;
        print(languages);
        if (languages == null || !languages.contains("ta-IN")) {
          // Show a pop-up indicating that the language is not supported
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Create and return an AlertDialog widget
              return AlertDialog(
                title: Text('Language Not Supported'),
                content: Text(
                    'Sorry, Voice is not supported for Tamil language in your device'),
                actions: <Widget>[
                  // Add an OK button to dismiss the dialog
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                    child: Text('This box closes in 5 seconds'),
                  ),
                ],
              );
            },
          );
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(); // Close the dialog after 5 seconds
          });
          return;
        } else {
          // Update user language settings if Tamil is supported
          user_language = "ta-IN";
          language_file = "tamil";
          updateColor(1, Colors.red);
          updateColor(0, Colors.blueAccent);
        }
        break;
      case 2:
        // Add your action for Back to Home Screen button
        Navigator.pop(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _handleButtonClick(_highlightedIndex);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Language'),
        ),
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    './lib/assets/test.jpg'), // Replace 'assets/background_image.jpg' with your image asset path
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _handleButtonClick(0),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                      color:
                          _highlightedIndex == 0 ? Colors.black : Colors.purple,
                      width: _highlightedIndex == 0 ? 7.0 : 1.0,
                    )),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => clrvalue[0],
                    ),
                  ),
                  child: Text(
                    'English',
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _handleButtonClick(1),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                      color:
                          _highlightedIndex == 1 ? Colors.black : Colors.purple,
                      width: _highlightedIndex == 1 ? 7.0 : 1.0,
                    )),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => clrvalue[1],
                    ),
                  ),
                  child: Text('Tamil',
                      style: TextStyle(color: Colors.black, fontSize: 18.0)),
                ),
                ElevatedButton(
                  onPressed: () => _handleButtonClick(2),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                      color:
                          _highlightedIndex == 2 ? Colors.black : Colors.purple,
                      width: _highlightedIndex == 2 ? 7.0 : 1.0,
                    )),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => clrvalue[2],
                    ),
                  ),
                  child: Text('Back to Home Screen',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
