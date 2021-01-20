import 'package:card_shuffling/widgets/card_shuffle_animation_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _showAnimation = false;

  void _toggle() => setState(
        () => _showAnimation = !_showAnimation,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(215),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
        ),
        child: RaisedButton(
          child: const Text(
            'Toggle',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: _toggle,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: _showAnimation
              ? CardShuffleAnimationWidget()
              : const Text(
                  'Tap on Toggle to start animation',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
}
