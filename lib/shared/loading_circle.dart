import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class LoadingCircle extends StatefulWidget {
  final bool animating;

  final double size;

  final int tickCount;

  final Color color;

  final Color inactiveColor;

  final Duration animationDuration;

  final double relativeWidth;

  final double startRatio;

  final double endRatio;

  const LoadingCircle({
    Key? key,
    this.animating = true,
    this.size = 10,
    this.startRatio = 0.5,
    this.endRatio = 1.0,
    this.tickCount = 8,
    this.color = const Color(0xFF9D9D9D),
    this.inactiveColor = const Color(0xFFE5E5EA),
    this.animationDuration = const Duration(seconds: 1),
    this.relativeWidth = 1,
  }) : super(key: key);

  @override
  _LoadingCirlceState createState() => _LoadingCirlceState();
}

class _LoadingCirlceState extends State<LoadingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    if (widget.animating) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(LoadingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.size * 2,
        width: widget.size * 2,
        child: CustomPaint(
          painter: _LoadingCirlcePainter(
            animationController: _animationController,
            size: widget.size,
            tickCount: widget.tickCount,
            color: widget.color,
            inactiveColor: widget.inactiveColor,
            relativeWidth: widget.relativeWidth,
            startRatio: widget.startRatio,
            endRatio: widget.endRatio,
          ),
        ),
      ),
    );
  }
}

class _LoadingCirlcePainter extends CustomPainter {
  final int _halfTickCount;
  final Animation<double> animationController;
  final Color color;
  final Color inactiveColor;
  final double relativeWidth;
  final int tickCount;
  final double size;
  final RRect _tickRRect;
  final double startRatio;
  final double endRatio;

  _LoadingCirlcePainter({
    required this.size,
    required this.tickCount,
    required this.animationController,
    required this.color,
    required this.inactiveColor,
    required this.relativeWidth,
    required this.startRatio,
    required this.endRatio,
  })  : _halfTickCount = tickCount ~/ 2,
        _tickRRect = RRect.fromLTRBXY(
          -size * endRatio,
          relativeWidth * size / 10,
          -size * startRatio,
          -relativeWidth * size / 10,
          1,
          1,
        ),
        super(repaint: animationController);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2);
    final activeTick = (tickCount * animationController.value).floor();
    for (int i = 0; i < tickCount; ++i) {
      paint.color = Color.lerp(
        color,
        inactiveColor,
        ((i + activeTick) % tickCount) / _halfTickCount,
      )!;
      canvas
        ..drawRRect(_tickRRect, paint)
        ..rotate(-math.pi * 2 / tickCount);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LoadingCirlcePainter oldPainter) {
    return oldPainter.animationController != animationController;
  }
}
