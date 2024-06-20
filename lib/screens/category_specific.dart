import 'dart:async';
import 'dart:convert';
import "dart:io";

import 'package:aac_srp/utils/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

import '../utils/constants.dart';

class CategorySpecific extends StatefulWidget {
  final String categoryName;

  CategorySpecific({required this.categoryName});

  @override
  _CategorySpecificState createState() => _CategorySpecificState();
}

class _CategorySpecificState extends State<CategorySpecific> {
  List<Map<String, dynamic>> _categoryIcons = [];
  int selectedIconCount = 4;
  int _currentPageIndex = 0;
  final FlutterTts flutterTts = FlutterTts();
  int _clickedIndex = -1;

  late Timer _timer;
  List<bool> _highlightedButtons = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  void initState() {
    super.initState();
    selectedIconCount = Constants.selectedIconCount;
    _loadCategoryIcons();
    _startHighlighting();
  }

  Future<void> _loadCategoryIcons() async {
    try {
      String jsonString = await rootBundle
          .loadString('lib/assets/${Constants.language_file}_category.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> categoriesData = jsonData['categories'];
      Map<String, dynamic>? categoryData = categoriesData.firstWhere(
        (category) => category['name'] == widget.categoryName,
        orElse: () => null,
      );
      if (categoryData != null) {
        setState(() {
          _categoryIcons =
              List<Map<String, dynamic>>.from(categoryData['imageIds']);
        });
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName),
        ),
        body: GestureDetector(
          onTap: () {
            // Find the index of the currently highlighted button
            int highlightedIndex = _highlightedButtons.indexOf(true);
            if (highlightedIndex != -1) {
              // Perform action corresponding to the highlighted button
              if (highlightedIndex == selectedIconCount) {
                _nextPage();
              } else if (highlightedIndex == selectedIconCount + 1) {
                _previousPage();
              } else if (highlightedIndex == selectedIconCount + 2) {
                _goToHomePage();
              } else {
                _handleIconTap(highlightedIndex);
              }
            }
          },
          child: Column(
            children: [
              Expanded(
                child: _buildIconGrid(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _previousPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _highlightedButtons[selectedIconCount + 1]
                                ? Colors.red
                                : null,
                      ),
                      child: Icon(Icons.arrow_back,
                          size: Platform.isAndroid
                              ? MediaQuery.of(context).size.width * 0.1
                              : MediaQuery.of(context).size.width * 0.01),
                    ),
                  ),
                  Text(
                    'Page ${_currentPageIndex + 1}',
                    style: TextStyle(
                        fontSize: Platform.isAndroid
                            ? MediaQuery.of(context).size.width * 0.05
                            : MediaQuery.of(context).size.width * 0.02,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _highlightedButtons[selectedIconCount]
                            ? Colors.red
                            : null,
                      ),
                      child: Icon(Icons.arrow_forward,
                          size: Platform.isAndroid
                              ? MediaQuery.of(context).size.width * 0.1
                              : MediaQuery.of(context).size.width * 0.01),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goToHomePage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _highlightedButtons[selectedIconCount + 2]
                                ? Colors.red
                                : null,
                      ),
                      child: Icon(Icons.home,
                          size: Platform.isAndroid
                              ? MediaQuery.of(context).size.width * 0.1
                              : MediaQuery.of(context).size.width * 0.01),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error building UI: $e');
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildIconGrid() {
    int startIndex = _currentPageIndex * selectedIconCount;
    int endIndex = startIndex + selectedIconCount < _categoryIcons.length
        ? startIndex + selectedIconCount
        : _categoryIcons.length;
    List<Map<String, dynamic>> currentPageIcons =
        _categoryIcons.sublist(startIndex, endIndex);

    int crossAxisCount = selectedIconCount == 4
        ? 2
        : selectedIconCount == 9
            ? 3
            : 4;

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(), // Disable scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: Platform.isWindows ? 2.2 : 1,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: currentPageIcons.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildIconCard(currentPageIcons[index], index);
      },
    );
  }

  Widget _buildIconCard(Map<String, dynamic> iconData, int index) {
    int actualIndex = _currentPageIndex * selectedIconCount + index;
    String imageId = iconData['id'].toString();
    String imagePath = 'lib/assets/symbols/$imageId.png';
    bool isClicked = _clickedIndex == actualIndex;
    return GestureDetector(
      onTap: () {
        _handleIconTap(index);
      },
      child: Card(
        color: isClicked && _highlightedButtons[index]
            ? Colors.lightGreenAccent.shade100
            : null, // Change card color based on clicked and highlighted state// Change card color based on highlighted state
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _speakText(iconData['text'].join(', ')),
                child: Image.asset(
                  imagePath,

                  width: MediaQuery.of(context).size.width *
                      0.2, // Adjust icon size based on screen width
                  height: MediaQuery.of(context).size.width *
                      0.2, // Adjust icon size based on screen width
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Flexible(
              child: Text(
                iconData['text'].join(", "),
                textAlign: TextAlign.center,
                maxLines: 2, // Limit to 2 lines
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ), // Ellipsis if exceeds 2 lines
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: _highlightedButtons[index] ? Colors.red : Colors.transparent,
            width: _highlightedButtons[index] ? 2 : 0,
          ),
        ),
      ),
    );
  }

  void _speakText(String text) async {
    // Set up FlutterTts and speak the provided text
    await flutterTts.setLanguage(user_language);

    // Check if the desired language is supported
    List<dynamic>? languages = await flutterTts.getLanguages;
    print(languages);
    if (languages == null || !languages.contains(user_language)) {
      // Show a pop-up indicating that the language is not supported
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Create and return an AlertDialog widget
          return AlertDialog(
            title: Text('Language Not Supported'),
            content:
                Text('Sorry, Voice is not supported for the selected Language'),
            actions: <Widget>[
              // Add an OK button to dismiss the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                child: Text('This Box Closes Automatically'),
              ),
            ],
          );
        },
      );
      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).pop(); // Close the dialog after 5 seconds
      });
      return;
    }

    // If the language is supported, continue with speaking the text
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);

    // Schedule the dialog to close after 5 seconds
  }

  void _nextPage() {
    setState(() {
      _currentPageIndex = (_currentPageIndex + 1) %
          ((_categoryIcons.length - 1) ~/ selectedIconCount + 1);
      _resetHighlightingTimer();
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
      } else {
        _currentPageIndex =
            ((_categoryIcons.length - 1) ~/ selectedIconCount).toInt();
      }
      _resetHighlightingTimer();
    });
  }

  void _goToHomePage() {
    Navigator.pop(context); // Navigate back to the previous screen
  }

  void _startHighlighting() {
    int timerCount = 0;
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _highlightedButtons = List.generate(
          selectedIconCount + 3,
          (index) => index == timerCount % (selectedIconCount + 3),
        );

        timerCount++;
        if (timerCount == (selectedIconCount + 3)) {
          timerCount = 0;
          _clickedIndex = -1; // Reset timerCount to loop around
        }
      });
    });
  }

  void _resetHighlightingTimer() {
    _timer.cancel();
    _startHighlighting();
  }

  void _handleIconTap(int index) {
    final int pageCount =
        (_categoryIcons.length + selectedIconCount - 1) ~/ selectedIconCount;

    try {
      final int pageIndex = index ~/ selectedIconCount;

      if (pageIndex < pageCount) {
        final int iconIndexOnPage = index % selectedIconCount;
        final int iconIndexInList =
            _currentPageIndex * selectedIconCount + iconIndexOnPage;

        // Check if the tapped icon is within the bounds of the icon list
        if (iconIndexInList < _categoryIcons.length) {
          // Speak the text associated with the tapped icon
          setState(() {
            _clickedIndex =
                iconIndexInList; // Set _clickedIndex to the clicked icon index
          });
          _speakText(_categoryIcons[iconIndexInList]['text'].join(', '));
        }
      } else {
        // Check if the tapped button is highlighted
        int buttonIndex = index - _categoryIcons.length * selectedIconCount;
        if (_highlightedButtons[buttonIndex]) {
          // Perform action corresponding to the tapped button
          switch (buttonIndex) {
            case 0: // Previous button
              _previousPage();
              break;
            case 1: // Next button
              _nextPage();
              break;
            case 2: // Home button
              _goToHomePage();
              break;
            default:
              break;
          }
        }
      }
    } catch (e) {
      print('Error handling icon tap: $e');
    }
  }
}
