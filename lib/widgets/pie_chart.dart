import 'package:flutter/material.dart';
import 'dart:math';

class PieChartSection extends StatelessWidget {
  final List<Map<String, dynamic>> segments;

  const PieChartSection({
    super.key,
    this.segments = const [
      {'value': 0.5, 'color': Colors.orange, 'label': '50%'},
      {'value': 0.4, 'color': Colors.amber, 'label': '40%'},
      {'value': 0.1, 'color': Colors.brown, 'label': '10%'},
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Distribución de Huevos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 250,
          height: 250,
          child: CustomPaint(
            painter: PieChartPainter(segments),
          ),
        ),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> segments;

  PieChartPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startRadian = -pi / 2;

    for (var segment in segments) {
      final value = segment['value'] as double;
      final color = segment['color'] as Color;
      final label = segment['label'] as String;
      final sweepRadian = value * 2 * pi;

      paint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        true,
        paint,
      );

      // Posicionar texto
      final labelAngle = startRadian + sweepRadian / 2;
      final labelOffset = Offset(
        center.dx + (radius / 1.5) * cos(labelAngle),
        center.dy + (radius / 1.5) * sin(labelAngle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(
        labelOffset.dx - textPainter.width / 2,
        labelOffset.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();

      startRadian += sweepRadian;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
