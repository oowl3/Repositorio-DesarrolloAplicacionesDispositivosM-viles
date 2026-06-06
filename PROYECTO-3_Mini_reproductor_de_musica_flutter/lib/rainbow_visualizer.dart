import 'dart:math';
import 'package:flutter/material.dart';

class RainbowVisualizer extends StatefulWidget {
  final bool isPlaying;
  const RainbowVisualizer({super.key, required this.isPlaying});

  @override
  State<RainbowVisualizer> createState() => _RainbowVisualizerState();
}

class _RainbowVisualizerState extends State<RainbowVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void didUpdateWidget(RainbowVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.isPlaying ? const Duration(milliseconds: 500) : const Duration(seconds: 6);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(size: Size.infinite, painter: _FlowPainter(time: _controller.value * 2 * pi, isPlaying: widget.isPlaying));
      },
    );
  }
}

class _FlowPainter extends CustomPainter {
  final double time;
  final bool isPlaying;
  _FlowPainter({required this.time, required this.isPlaying});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0A0A0E));
    
    // Dibujamos 3 hilos de energía
    for (int i = 0; i < 4; i++) {
      final path = Path();
      final double yCenter = (size.height / 2) + ((i - 1) * 30.0); 
      final double phaseShift = i * 2.0;

      path.moveTo(0, yCenter);
      for (double x = 0; x <= size.width; x += 3) {
        final normalizedX = x / size.width;
        double y;
        if (isPlaying) {
          final amplitude = 20.0 + (pow(sin(time + phaseShift), 8) * (80.0 - (i * 10)));
          y = yCenter + (sin(normalizedX * pi * 1.5 + time * 1.5 + phaseShift) + cos(normalizedX * pi * 2.0 - time)) * amplitude;
        } else {
          y = yCenter; 
        }
        path.lineTo(x, y);
      }
      
      final Color color = const Color.fromARGB(255, 93, 64, 255);
      // Capas de brillo (Efecto neón)
      canvas.drawPath(path, Paint()..color = color.withOpacity(isPlaying ? 0.3 : 0.05)..style = PaintingStyle.stroke..strokeWidth = isPlaying ? 10.0 : 2.0..maskFilter = MaskFilter.blur(BlurStyle.normal, isPlaying ? 10 : 1));
      canvas.drawPath(path, Paint()..color = color.withOpacity(isPlaying ? 0.6 : 0.2)..style = PaintingStyle.stroke..strokeWidth = isPlaying ? 3.0 : 0.8..maskFilter = MaskFilter.blur(BlurStyle.normal, isPlaying ? 2 : 1));
      canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(isPlaying ? 0.9 : 0.4)..style = PaintingStyle.stroke..strokeWidth = isPlaying ? 1.2 : 0.4);
    }
  }
  @override
  bool shouldRepaint(covariant _FlowPainter oldDelegate) => true;
}