import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madalh/exportConstants.dart';
import 'package:madalh/homePage.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import '../controllers/questionsController.dart';

class linearMesure extends StatefulWidget {
  const linearMesure({Key? key}) : super(key: key);

  @override
  State<linearMesure> createState() => _linearMesureState();
}

class _linearMesureState extends State<linearMesure> {
  double _pointerValue = 0;

  Widget linearMesure() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          constants.smallText('ما هو طول الشريك المناسب؟', context,
              color: Colors.redAccent),
          FittedBox(
            child: Container(
              padding: EdgeInsets.all(10),
              child: SfLinearGauge(
                maximum: 250,
                animateAxis: true,
                axisTrackStyle: const LinearAxisTrackStyle(),
                markerPointers: <LinearMarkerPointer>[
                  LinearShapePointer(
                      value: _pointerValue,
                      enableAnimation: false,
                      onChanged: (dynamic value) {
                        setState(() {
                          _pointerValue = value as double;
                        });
                      },
                      shapeType: LinearShapePointerType.rectangle,
                      color: Theme.of(context).primaryColor,
                      height: 1.5,
                      width: 250),
                  LinearWidgetPointer(
                      value: _pointerValue,
                      enableAnimation: false,
                      onChanged: (dynamic value) {
                        setState(() {
                          _pointerValue = value as double;
                        });
                      },
                      child: SizedBox(
                          width: 24,
                          height: 16,
                          child: Image.asset(
                            'assets/images/rectangle_pointer.png',
                          ))),
                  LinearWidgetPointer(
                      value: _pointerValue,
                      enableAnimation: false,
                      onChanged: (dynamic value) {
                        setState(() {
                          _pointerValue = value as double;
                        });
                      },
                      offset: constants.screenWidth * 0.7,
                      position: LinearElementPosition.outside,
                      child: Container(
                          width: 60,
                          height: 25,
                          decoration: BoxDecoration(
                              color: constants.greyC,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: constants.greyC,
                                  offset: const Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: Text(
                                _pointerValue.toStringAsFixed(0) + ' cm',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor)),
                          ))),
                ],
                ranges: <LinearGaugeRange>[
                  LinearGaugeRange(
                    endValue: _pointerValue,
                    startWidth: 200,
                    midWidth: 300,
                    endWidth: 200,
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/images/femaleTall.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
                onGenerateLabels: () {
                  return <LinearAxisLabel>[
                    const LinearAxisLabel(text: '0 cm', value: 0),
                    const LinearAxisLabel(text: '25 cm', value: 25),
                    const LinearAxisLabel(text: '50 cm', value: 50),
                    const LinearAxisLabel(text: '75 cm', value: 75),
                    const LinearAxisLabel(text: '100 cm', value: 100),
                    const LinearAxisLabel(text: '125 cm', value: 125),
                    const LinearAxisLabel(text: '150 cm', value: 150),
                    const LinearAxisLabel(text: '175 cm', value: 175),
                    const LinearAxisLabel(text: '200 cm', value: 200),
                    const LinearAxisLabel(text: '225 cm', value: 225),
                    const LinearAxisLabel(text: '250 cm', value: 250),
                  ];
                },
                orientation: LinearGaugeOrientation.vertical,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          linearMesure(),
        ],
      ),
    );
  }
}





class MCQuestion {
  String question;
  List<MCAnswers> answers;

  MCQuestion({required this.question, required this.answers});
}

class MCAnswers {
  bool isChosen;
  final String AnswerText;

  MCAnswers({
    required this.AnswerText,
    this.isChosen = false,
  });
}




// class horizMesure extends StatefulWidget {
//   const horizMesure({Key? key}) : super(key: key);
//
//   @override
//   State<horizMesure> createState() => _horizMesureState();
// }
//
// class _horizMesureState extends State<horizMesure> {
//   double _pointerValue = 0;
//
//   Widget linearMesure() {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           constants.smallText('ما هو وزن الشريك المناسب؟', context,
//               color: Colors.redAccent),
//           FittedBox(
//             child: Container(
//               padding: EdgeInsets.all(10),
//               child: SfLinearGauge(
//
//                 maximum: 250,
//                 animateAxis: true,
//                 axisTrackStyle: const LinearAxisTrackStyle(),
//                 markerPointers: <LinearMarkerPointer>[
//                   LinearShapePointer(
//                       value: _pointerValue,
//                       enableAnimation: false,
//                       onChanged: (dynamic value) {
//                         setState(() {
//                           _pointerValue = value as double;
//                         });
//                       },
//                       shapeType: LinearShapePointerType.rectangle,
//                       color: Theme
//                           .of(context)
//                           .primaryColor,
//                       height: 1.5,
//                       width: 20),
//                   LinearWidgetPointer(
//                       value: _pointerValue,
//                       enableAnimation: false,
//                       onChanged: (dynamic value) {
//                         setState(() {
//                           _pointerValue = value as double;
//                         });
//                       },
//                       child: SizedBox(
//                           width: 24,
//                           height: 16,
//                           child: Transform(
//                             alignment: FractionalOffset.center,
//                             transform: new Matrix4.identity()
//                               ..rotateZ(90 * 3.1415927 / 180),
//                             child: Image.asset(
//                               'assets/images/rectangle_pointer.png',
//                             ),
//                           ))),
//                   LinearWidgetPointer(
//                       value: _pointerValue,
//                       enableAnimation: false,
//                       onChanged: (dynamic value) {
//                         setState(() {
//                           _pointerValue = value as double;
//                         });
//                       },
//                       offset: constants.screenWidth * 0.7,
//                       position: LinearElementPosition.outside,
//                       child: Container(
//                           width: 60,
//                           height: 25,
//                           decoration: BoxDecoration(
//                               color: constants.greyC,
//                               boxShadow: <BoxShadow>[
//                                 BoxShadow(
//                                   color: constants.greyC,
//                                   offset: const Offset(0.0, 1.0), //(x,y)
//                                   blurRadius: 6.0,
//                                 ),
//                               ],
//                               borderRadius: BorderRadius.circular(4)),
//                           child: Center(
//                             child: Text(
//                                 _pointerValue.toStringAsFixed(0) + ' kg',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                     color: Theme
//                                         .of(context)
//                                         .primaryColor)),
//                           ))),
//                 ],
//                 ranges: <LinearGaugeRange>[
//                   LinearGaugeRange(
//                     endValue: _pointerValue,
//
//                     startWidth: 250,
//                     midWidth: 300,
//                     endWidth: 300,
//                     color: Colors.transparent,
//                     child: Image.asset(
//                       'assets/images/femaleTall.png',
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ],
//                 onGenerateLabels: () {
//                   return <LinearAxisLabel>[
//
//
//                     const LinearAxisLabel(text: '45 kg', value: 50),
//                     const LinearAxisLabel(text: '75 kg', value: 75),
//                     const LinearAxisLabel(text: '100 kg', value: 100),
//                     const LinearAxisLabel(text: '125 kg', value: 125),
//                     const LinearAxisLabel(text: '150 kg', value: 150),
//                     const LinearAxisLabel(text: '175 kg', value: 175),
//                     const LinearAxisLabel(text: '200 kg', value: 200),
//
//                   ];
//                 },
//                 orientation: LinearGaugeOrientation.horizontal,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           linearMesure(),
//         ],
//       ),
//     );
//   }
// }
