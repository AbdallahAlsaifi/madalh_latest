import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class BodyCustomizationScreen extends StatefulWidget {
//   @override
//   _BodyCustomizationScreenState createState() =>
//       _BodyCustomizationScreenState();
// }
//
// class _BodyCustomizationScreenState extends State<BodyCustomizationScreen> {
//   double _bodyWidth = 50;
//   double _bodyHeight = 100;
//   double _bodyWeight = 70;
//   Color _bodyColor = Colors.redAccent;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Body Customization'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               child: CustomPaint(
//                 painter: BodyPainter(
//                   bodyWidth: _bodyWidth,
//                   bodyHeight: _bodyHeight,
//                   bodyWeight: _bodyWeight,
//                   bodyColor: _bodyColor,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text('Body Width'),
//                 Slider(
//                   max: 200,
//                   value: _bodyWidth,
//                   onChanged: (value) {
//                     setState(() {
//                       _bodyWidth = value;
//                     });
//                   },
//                 ),
//                 Text('Body Height'),
//                 Slider(
//                   max: 200,
//                   value: _bodyHeight,
//                   onChanged: (value) {
//                     setState(() {
//                       _bodyHeight = value;
//                     });
//                   },
//                 ),
//                 Text('Body Weight'),
//                 Slider(
//                   max: 200,
//                   value: _bodyWeight,
//                   onChanged: (value) {
//                     setState(() {
//                       _bodyWeight = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class BodyPainter extends CustomPainter {
//   BodyPainter({
//     required this.bodyWidth,
//     required this.bodyHeight,
//     required this.bodyWeight,
//     required this.bodyColor,
//   });
//
//   final double bodyWidth;
//   final double bodyHeight;
//   final double bodyWeight;
//   final Color bodyColor;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = bodyColor;
//     final headRadius = bodyHeight / 10;
//     final torsoHeight = bodyHeight * 0.6;
//     final armHeight = torsoHeight / 2;
//     final legHeight = bodyHeight * 0.3;
//     final hipWidth = bodyWidth / 4;
//     final shoulderWidth = bodyWidth / 2;
//     final kneeWidth = bodyWidth / 8;
//     final ankleWidth = bodyWidth / 4;
//
//     final centerX = size.width / 2;
//     final centerY = size.height / 2;
//
//     // Draw head
//     canvas.drawCircle(
//       Offset(centerX, centerY - torsoHeight / 2 - headRadius),
//       headRadius,
//       paint,
//     );
//
//     // Draw torso
//     canvas.drawRect(
//       Rect.fromLTWH(centerX - hipWidth / 2, centerY - torsoHeight / 2, hipWidth, torsoHeight),
//       paint,
//     );
//
//     // Draw arms
//     canvas.drawRect(
//       Rect.fromLTWH(centerX - shoulderWidth / 2, centerY - armHeight / 2, shoulderWidth, armHeight),
//       paint,
//     );
//
//     // Draw legs
//     canvas.drawRect(
//       Rect.fromLTWH(centerX - kneeWidth / 2, centerY + legHeight / 2, kneeWidth, legHeight),
//       paint,
//     );
//     canvas.drawRect(
//       Rect.fromLTWH(centerX - ankleWidth / 2, centerY + legHeight * 1.5, ankleWidth, legHeight),
//       paint,
//     );
//
//   }
//
//   @override
//   bool shouldRepaint(BodyPainter oldDelegate) {
//     return oldDelegate.bodyWidth != bodyWidth ||
//         oldDelegate.bodyHeight != bodyHeight ||
//         oldDelegate.bodyWeight != bodyWeight ||
//         oldDelegate.bodyColor != bodyColor;
//   }
// }

class HumanBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 200,
      child: CustomPaint(
        painter: BodyPainter(),
      ),
    );
  }
}
class BodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    // torso
    var torsoHeight = size.height * 0.7;
    var torsoWidth = size.width * 0.5;
    var torsoX = size.width / 2 - torsoWidth / 2;
    var torsoY = size.height - torsoHeight;
    var torsoRect = Rect.fromLTWH(torsoX, torsoY, torsoWidth, torsoHeight);
    canvas.drawRect(torsoRect, paint);

    // neck
    var neckHeight = size.height * 0.1;
    var neckY = size.height - torsoHeight - neckHeight;
    var neckRect = Rect.fromLTWH(torsoX, neckY, torsoWidth, neckHeight);
    canvas.drawRect(neckRect, paint);

    // head
    var headRadius = size.width * 0.15;
    var headX = size.width / 2;
    var headY = neckY - headRadius;
    canvas.drawCircle(Offset(headX, headY), headRadius, paint);

    // eyes
    var eyeRadius = size.width * 0.02;
    var eyeSpacing = headRadius * 0.5;
    var eyeX = headX - eyeSpacing;
    var eyeY = headY - eyeRadius;
    canvas.drawCircle(Offset(eyeX, eyeY), eyeRadius, paint);
    eyeX = headX + eyeSpacing;
    canvas.drawCircle(Offset(eyeX, eyeY), eyeRadius, paint);

    // mouth
    var mouthWidth = headRadius * 0.7;
    var mouthHeight = headRadius * 0.2;
    var mouthX = headX - mouthWidth / 2;
    var mouthY = headY + headRadius * 0.2;
    var mouthRect = Rect.fromLTWH(mouthX, mouthY, mouthWidth, mouthHeight);
    canvas.drawRect(mouthRect, paint);

    // arms
    var armWidth = size.width * 0.1;
    var armHeight = size.height * 0.3;
    var armX = size.width / 2 - torsoWidth / 2 - armWidth;
    var armY = size.height - torsoHeight * 0.6;
    var armRect = Rect.fromLTWH(armX, armY, armWidth, armHeight);
    canvas.drawRect(armRect, paint);

    // legs
    var legWidth = size.width * 0.15;
    var legHeight = size.height * 0.4;
    var legX = size.width / 2 - legWidth / 2;
    var legY = size.height - legHeight;
    var legRect = Rect.fromLTWH(legX, legY, legWidth, legHeight);
    canvas.drawRect(legRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}