import 'package:flutter/material.dart';

class Painter extends ChangeNotifier implements CustomPainter {
  Color strokeColor;
  var strokes = List<List<Offset>>();

  Painter(this.strokeColor);

  bool hitTest(Offset position) => null;

  void startStroke(Offset position) {
    strokes.add([position]);
    notifyListeners();
  }

  void appendStroke(Offset position) {
    var stroke = strokes.last;
    stroke.add(position);
    notifyListeners();
  }

  void endStroke() {
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint fillPaint = Paint();
    fillPaint.color = Colors.yellow[300];
    fillPaint.style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    Paint strokePaint = new Paint();
    strokePaint.color = Colors.black;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeWidth = 5.0;

    for (var stroke in strokes) {
      Path strokePath = new Path();
      strokePath.addPolygon(stroke, false);
      canvas.drawPath(strokePath, strokePaint);
    }
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return false;
  }
}
