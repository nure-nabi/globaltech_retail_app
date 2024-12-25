import 'dart:async';
import 'package:flutter/material.dart';
import 'package:retail_app/constants/assets_list.dart';

class ScrollingImages extends StatefulWidget {
  const ScrollingImages({super.key});

  @override
  _ScrollingImagesState createState() => _ScrollingImagesState();
}

class _ScrollingImagesState extends State<ScrollingImages> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 100) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      width: 200.0,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 5000,
        itemBuilder: (context, index) {
        //  if (index % 2== 0) {
            return _buildImageCard(AssetsList.bannerImage);
         // }
          // else {
          //   return _buildImageCard(AssetsList.abPallet);
          // }
        },
      ),
    );
  }


  Widget _buildImageCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 200.0,
          width: 350.0,
          child: Image.asset(
            imagePath,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}