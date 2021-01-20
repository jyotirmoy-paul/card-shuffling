import 'package:card_shuffling/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:card_shuffling/models/card.dart' as cardModel;

class CardBackWidget extends StatefulWidget {
  final cardModel.Card card;

  CardBackWidget({
    Key key,
    this.card,
  }) : super(key: key);

  @override
  CardBackWidgetState createState() => CardBackWidgetState();
}

class CardBackWidgetState extends State<CardBackWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  double getNewDx() =>
      widget.card.dx +
      (_animation.value * (widget.card.dx + widget.card.xTarget));

  double getNewDy() =>
      widget.card.dy +
      (_animation.value * (widget.card.dy + widget.card.yTarget));

  void animate() => Future.delayed(Duration(milliseconds: widget.card.delay))
      .then((_) => _controller.forward());

  void animateReverse() => _controller.reverse();

  void animateDispose() => _controller.dispose();

  Widget _buildCardBack({
    double dx,
    double dy,
  }) =>
      Transform.translate(
        offset: Offset(
          dx,
          dy,
        ),
        child: Container(
          height: kCardHeight,
          width: kCardWidth,
          decoration: BoxDecoration(),
          child: Image.asset(
            widget.card.cardBackImageAsset,
          ),
        ),
      );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: kCardShufflingAnimationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => _buildCardBack(
        dx: getNewDx(),
        dy: getNewDy(),
      ),
    );
  }
}
