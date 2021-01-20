import 'dart:math';

import 'package:card_shuffling/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:card_shuffling/models/card.dart' as cardModel;

const delayConst = 8;
const restOffsetMultiplier = 1 / 10;

class CardShuffleAnimationWidget extends StatefulWidget {
  @override
  _CardShuffleAnimationWidgetState createState() =>
      _CardShuffleAnimationWidgetState();
}

class _CardShuffleAnimationWidgetState
    extends State<CardShuffleAnimationWidget> {
  final _noOfCards = 10;
  final List<cardModel.Card> _cards = [];

  Future<void> _animationWait() => Future.delayed(
        Duration(
          milliseconds: kCardShufflingAnimationDuration.inMilliseconds +
              (_noOfCards - 1) * delayConst,
        ),
      );

  double getXTarget(int i, var randomizer) =>
      (kCardWidth / 2 + (kCardWidth / 1.5) * randomizer.nextDouble());

  void _animateCards() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animate();
  }

  void _animateCardsReverse() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animateReverse();
  }

  void _animateDispose() {
    for (int i = 0; i < _cards.length; i++) _cards[i].animateDispose();
  }

  /* this method, makes the mixing of cards looks more realistic */
  /* swap the positions of left and right cards, without changing their particular
  order in either left or right sides */
  void _processCards() {
    int leftPtr = _noOfCards - 1; // points to a -ve xTargetElement
    int rightPtr = _noOfCards - 1; // points to a +ve xTargetElement

    while (leftPtr >= 0 && rightPtr >= 0) {
      // leftPtr find a -ve element
      while (leftPtr >= 0) {
        if (_cards[leftPtr].xTarget < 0)
          break;
        else
          leftPtr--;
      }

      if (leftPtr < 0) break;

      // rightPtr find a +ve element
      while (rightPtr >= 0) {
        if (_cards[rightPtr].xTarget > 0)
          break;
        else
          rightPtr--;
      }

      if (rightPtr < 0) break;

      // swap leftPtr element and rightPtr element
      if (leftPtr >= 0 && rightPtr >= 0) {
        var temp = _cards[leftPtr];
        _cards[leftPtr] = _cards[rightPtr];
        _cards[rightPtr] = temp;
      } else {
        break;
      }

      leftPtr--;
      rightPtr--;
    }
  }

  /* this method sorts the cards as per the initial index value */
  /* as delay is in sorted order, the array is thus sorted using delay */
  void _normalizeCards() {
    var randomizer = Random();

    _cards.sort((a, b) => a.delay.compareTo(b.delay));

    /* initiate with new xTargetValue */
    for (int i = 0; i < _cards.length; i++) {
      _cards[i].xTarget = getXTarget(i, randomizer);
      if (randomizer.nextBool()) _cards[i].xTarget *= -1;
    }
  }

  Future<void> _playAnimation({bool reset = true}) async {
    _animateCards();

    // wait till the fist half of animation finishes
    await _animationWait();

    if (mounted) setState(() => _processCards());

    _animateCardsReverse();

    // wait till the second half of animation finishes
    await _animationWait();

    if (mounted && reset) setState(() => _normalizeCards());
  }

  void _initAnimate() async {
    Random randomizer = Random();
    String cardBackAssetImage = kCardBackAssets[randomizer.nextInt(2)];

    for (int i = 0; i < _noOfCards; i++) {
      cardModel.Card card = cardModel.Card(
        cardBackImageAsset: cardBackAssetImage,
        dx: -2 * i * restOffsetMultiplier,
        dy: -2 * i * restOffsetMultiplier,
        xTarget: getXTarget(i, randomizer),
        yTarget: 0,
        delay: delayConst * i,
      );

      if (randomizer.nextBool()) {
        card.xTarget *= -1;
      } else {}

      _cards.add(card);
    }

    /* wait for a brief moment before starting animation */
    await Future.delayed(kCardShufflingWaitDuration);

    /* _playAnimation invokes the animation - here the entire animation plays for 3 times */
    await _playAnimation();
    await _playAnimation();
    await _playAnimation(reset: false);
  }

  @override
  void initState() {
    super.initState();
    _initAnimate();
  }

  @override
  void dispose() {
    super.dispose();

    _animateDispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: _cards.map((c) => c.widget).toList(),
    );
  }
}
