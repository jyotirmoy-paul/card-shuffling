import 'package:card_shuffling/widgets/card_back_widget.dart';
import 'package:flutter/material.dart';

class Card {
  final GlobalKey<CardBackWidgetState> _key = GlobalKey();
  String cardBackImageAsset;
  double dx;
  double dy;

  double xTarget;
  double yTarget;

  /* delay in milliseconds */
  int delay;

  Card({
    @required this.xTarget,
    @required this.yTarget,
    this.cardBackImageAsset,
    this.dx = 0,
    this.dy = 0,
    this.delay = 0,
  });

  void animate() => _key.currentState?.animate();
  void animateReverse() => _key.currentState?.animateReverse();
  void animateDispose() => _key.currentState?.animateDispose();

  double getNewDx() => _key.currentState.getNewDx();
  double getNewDy() => _key.currentState.getNewDy();

  Widget get widget => CardBackWidget(
        key: _key,
        card: this,
      );
}
