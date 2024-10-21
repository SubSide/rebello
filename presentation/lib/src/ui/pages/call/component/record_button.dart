import 'package:flutter/material.dart';

class RecordState extends State<RecordButton> {
  bool _isPressed = false;

  void onPressed() {
    setState(() {
      _isPressed = true;
    });
    widget.onPress();
  }

  void onReleased() {
    setState(() {
      _isPressed = false;
    });
    widget.onRelease();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (details) {
          onPressed();
        },
        onPointerUp: (details) {
          onReleased();
        },
        child: Container(
            decoration: BoxDecoration(
                color: _isPressed
                    ? Theme.of(context).colorScheme.primary.withAlpha(100)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2)),
            child: Center(
                child: Text('Speak', style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.primary)))));
  }
}

class RecordButton extends StatefulWidget {
  const RecordButton({super.key, required this.onPress, required this.onRelease});

  final Function onPress;
  final Function onRelease;

  @override
  RecordState createState() => RecordState();
}
