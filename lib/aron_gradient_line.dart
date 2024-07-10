library aron_gradient_line;

import 'package:flutter/material.dart';

/// Creates a AronGradientLine.
///
/// This class creates an instance of [StatefulWidget].
class AronGradientLine extends StatefulWidget {
  final Duration duration;
  final double height;
  final List<Color> colors;

  const AronGradientLine({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.height = 4.0,
    this.colors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ],
  });

  Color interpolateColor(double value) {
    final index1 = value.floor();
    final index2 = value.ceil();
    final fraction = value - index1;
    final color1 = colors[index1 % colors.length];
    final color2 = colors[index2 % colors.length];

    return Color.lerp(color1, color2, fraction)!;
  }

  @override
  State createState() => _AronGradientLineState();
}

class _AronGradientLineState extends State<AronGradientLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _animation = Tween(begin: 0.0, end: widget.colors.length.toDouble() - 1)
        .animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.interpolateColor(_animation.value),
            widget.interpolateColor(_animation.value + 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
