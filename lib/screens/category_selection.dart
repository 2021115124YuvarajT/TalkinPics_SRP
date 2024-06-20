import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'category_specific.dart';
import 'package:aac_srp/utils/constants.dart' as Constants;
import "dart:io";

class CategorySelection extends StatefulWidget {
  static const String id = 'category_selection';

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  List<Category> _categories = [];
  int selectedIconCount = 4;
  int _currentPageIndex = 0;
  List<bool> _highlightedButtons = List.filled(7, false);
  late Timer _timer;
  int _clickIndex = -1;
  bool isNextClicked = false;
  bool isPreviousClicked = false;
  @override
  void initState() {
    super.initState();
    _loadCategories();
    selectedIconCount = Constants.selectedIconCount;
  }

  Future<void> _loadCategories() async {
    try {
      String jsonString = await rootBundle
          .loadString('lib/assets/${Constants.language_file}_category.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> categoriesData = jsonData['categories'];
      setState(() {
        _categories =
            categoriesData.map((data) => Category.fromJson(data)).toList();
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startHighlighting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Selection'),
      ),
      body: GestureDetector(
        onTap: () {
          int highlightedIndex = _highlightedButtons.indexOf(true);
          print(highlightedIndex);
          if (highlightedIndex != -1) {
            if (highlightedIndex < selectedIconCount) {
              _handleButtonClick(highlightedIndex);
            } else if (highlightedIndex == selectedIconCount) {
              _nextPage();
            } else if (highlightedIndex == selectedIconCount + 1) {
              _previousPage();
            } else if (highlightedIndex == selectedIconCount + 2) {
              _goToHomePage();
            }
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
            child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    try {
      return Column(
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
                    backgroundColor: _highlightedButtons[selectedIconCount + 1]
                        ? Colors.red
                        : null,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Icon(
                      Icons.arrow_back,
                      size: Platform.isAndroid
                          ? MediaQuery.of(context).size.width * 0.1
                          : MediaQuery.of(context).size.width * 0.01,
                      weight: 70,
                    ),
                  ),
                ),
              ),
              Text(
                'Page ${_currentPageIndex + 1}',
                style: TextStyle(
                    fontSize: Platform.isAndroid
                        ? MediaQuery.of(context).size.width * 0.06
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
                  child: Icon(
                    Icons.arrow_forward,
                    size: Platform.isAndroid
                        ? MediaQuery.of(context).size.width * 0.1
                        : MediaQuery.of(context).size.width * 0.01,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _goToHomePage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _highlightedButtons[selectedIconCount + 2]
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
      );
    } catch (e) {
      print('Error building body: $e');
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _buildCategoryCard(Category category, int index) {
    try {
      String firstImageId = category.imageIds.isNotEmpty
          ? category.imageIds[0]['id'].toString()
          : '';
      int actualIndex = _currentPageIndex * selectedIconCount + index;
      bool isClicked = _clickIndex == actualIndex;
      return GestureDetector(
        onTap: () {
          _handleButtonClick(index);
        },
        child: Card(
          color: isClicked && _highlightedButtons[index]
              ? Colors.lightGreenAccent.shade100
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/symbols/$firstImageId.png',
                width: MediaQuery.of(context).size.width *
                    (Constants.selectedIconCount == 4 ? 0.15 : 0.08),
                height: MediaQuery.of(context).size.width *
                    (Constants.selectedIconCount == 4 ? 0.15 : 0.08),
                fit: BoxFit.scaleDown,
              ),
              Flexible(
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2, // Limit to 2 lines
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  _highlightedButtons[index] ? Colors.red : Colors.transparent,
              width: _highlightedButtons[index] ? 6 : 0,
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error building category card: $e');
      rethrow; // Rethrow the exception
    }
  }

  Widget _buildIconGrid() {
    try {
      int startIndex = _currentPageIndex * selectedIconCount;

      int endIndex = startIndex + selectedIconCount < _categories.length
          ? startIndex + selectedIconCount
          : _categories.length;
      List<Category> currentPageCategories =
          _categories.sublist(startIndex, endIndex);

      int crossAxisCount = selectedIconCount == 4
          ? 2
          : selectedIconCount == 9
              ? 3
              : 4;
      print("The width: ${MediaQuery.of(context).size.width}");
      print("The height: ${MediaQuery.of(context).size.height}");

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: Platform.isWindows ? 2.2 : 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: currentPageCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCategoryCard(currentPageCategories[index], index);
        },
      );
    } catch (e) {
      print('Error building icon grid: $e');
      rethrow; // Rethrow the exception
    }
  }

  void _updateHighlightedButtons() {
    _highlightedButtons = List.generate(
      selectedIconCount + 3,
      (index) => false,
    );
  }

  void _nextPage() {
    setState(() {
      _currentPageIndex = (_currentPageIndex + 1) %
          ((_categories.length - 1) ~/ selectedIconCount + 1);
      _resetHighlightingTimer();
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
      } else {
        _currentPageIndex =
            ((_categories.length - 1) ~/ selectedIconCount).toInt();
      }
      _resetHighlightingTimer();
    });
  }

  void _goToHomePage() {
    Navigator.pop(context);
  }

  void _startHighlighting() {
    int timerCount = 0;
    _timer =
        Timer.periodic(Duration(seconds: Constants.timerDuration), (timer) {
      setState(() {
        _highlightedButtons = List.generate(
          selectedIconCount + 3,
          (index) => index == timerCount % (selectedIconCount + 3),
        );
        timerCount++;
        if (timerCount == (selectedIconCount + 3)) {
          timerCount = 0;
          _clickIndex = -1;
        }
      });
    });
  }

  void _resetHighlightingTimer() {
    _timer.cancel();
    _updateHighlightedButtons();
    _startHighlighting();
  }

  void _handleButtonClick(int index) {
    int startIndex = _currentPageIndex * selectedIconCount;
    int selectedIndex = startIndex + index;
    if (selectedIndex < _categories.length) {
      setState(() {
        _clickIndex = selectedIndex;
      });

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategorySpecific(categoryName: _categories[selectedIndex].name),
          ),
        );
      });
    }
  }
}

class Category {
  final String name;
  final List<Map<String, dynamic>> imageIds;

  Category({required this.name, required this.imageIds});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      imageIds: List<Map<String, dynamic>>.from(json['imageIds']),
    );
  }
}
