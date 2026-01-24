import 'package:flutter/material.dart';

class HeartbeatLogo extends StatefulWidget {
  final double height;

  const HeartbeatLogo({
    super.key,
    this.height = 100, // Default height
  });

  @override
  State<HeartbeatLogo> createState() => _HeartbeatLogoState();
}

class _HeartbeatLogoState extends State<HeartbeatLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000), // animazione totale di 2 secondi
      vsync: this,
    );

    // animazione in 5 fasi dove variamo la scala del logo
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0, 
          end: 1.12).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.12, 
          end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0, 
          end: 1.06).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.06, 
          end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 40,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Image.asset(
        'assets/images/logo.png',
        height: widget.height,
      ),
    );
  }
}
