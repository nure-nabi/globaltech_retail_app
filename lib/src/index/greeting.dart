import 'package:flutter/material.dart';

import '../../constants/text_style.dart';

class GreetingText extends StatefulWidget {
  const GreetingText({Key? key}) : super(key: key);

  @override
  _GreetingTextState createState() => _GreetingTextState();
}

class _GreetingTextState extends State<GreetingText> {
  late String _greeting;

  @override
  void initState() {
    super.initState();
    _updateGreeting();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;

    setState(() {
      if (hour < 12) {
        _greeting = 'Good Morning!';
      } else if (hour < 17) {
        _greeting = 'Good Afternoon!';
      } else {
        _greeting = 'Good Evening!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _greeting,
      style:  cardTextStyleHeader,
    );
  }
}