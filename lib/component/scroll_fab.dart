import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollFab extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollFab(
    this.scrollController, {
    super.key,
  });

  @override
  State createState() => _ScrollFabState();
}

class _ScrollFabState extends State<ScrollFab> {
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          _showFab = false;
        });
      } else {
        setState(() {
          _showFab = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _showFab,
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              mini: true,
              elevation: 0,
              backgroundColor: Colors.grey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              onPressed: () {
                widget.scrollController.animateTo(
                  widget.scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_up),
            ),
            const SizedBox(height: 2),
            FloatingActionButton(
              mini: true,
              elevation: 0,
              backgroundColor: Colors.grey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              onPressed: () {
                widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_down),
            )
          ],
        ),
      ),
    );
  }
}
