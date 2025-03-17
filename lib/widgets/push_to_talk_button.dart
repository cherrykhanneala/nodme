import 'package:flutter/material.dart';

class PushToTalkButton extends StatefulWidget {
  final Function onPressed; // The callback function to be executed when the button is pressed

  const PushToTalkButton({required this.onPressed, super.key});

  @override
  _PushToTalkButtonState createState() => _PushToTalkButtonState();
}

class _PushToTalkButtonState extends State<PushToTalkButton> {
  bool isPressed = false; // Tracks the button's state (pressed or not)

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressDown: (_) {
        setState(() {
          isPressed = true; // Start the PTT session
        });
        widget.onPressed(); // Call the onPressed callback
      },
      onLongPressUp: () {
        setState(() {
          isPressed = false; // End the PTT session
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPressed ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
