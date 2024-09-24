import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GridComponent extends PositionComponent {
  final int rows;
  final int columns;
  final double cellSize;
  final Paint gridPaint;

  GridComponent({
    required this.rows,
    required this.columns,
    required this.cellSize,
    Color gridColor = Colors.black,
  }) : gridPaint = Paint()
    ..color = gridColor
    ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    for (int i = 0; i <= rows; i++) {
      final y = i * cellSize;
      canvas.drawLine(Offset(0, y), Offset(columns * cellSize, y), gridPaint);
    }
    for (int j = 0; j <= columns; j++) {
      final x = j * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, rows * cellSize), gridPaint);
    }
  }
}