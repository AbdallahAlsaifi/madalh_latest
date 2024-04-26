import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:step_tracker/step_tracker.dart';

class GoalLine extends StatelessWidget {
  final int listofRemainingLength;
  final int listOfAllLength;
  final IconData startIcon;
  final IconData personIcon;
  final IconData endIcon;

  GoalLine({
    required this.listofRemainingLength,
    required this.listOfAllLength,
    required this.startIcon,
    required this.personIcon,
    required this.endIcon,
  });

  double scaleWidth(double number, double originalWidth, double desiredWidth) {
    return (number / originalWidth) * desiredWidth;
  }
  @override
  Widget build(BuildContext context) {
    print(listOfAllLength);
    print(listofRemainingLength);

    return Container(
      width: 260,
      margin: EdgeInsets.only(top: 50, bottom: 50),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: StepTracker(
        dotSize: 10,
        selectedColor: listofRemainingLength >= 8 ? Colors.amber : Colors.green,
        unSelectedColor: Colors.red,
        stepTrackerType: StepTrackerType.indexedHorizontal,
        pipeSize: 30,
        steps: [
          Steps(title: Text("0%"), state: TrackerState.complete),
          Steps(title: Text("25%"), state: 10/4 <= listofRemainingLength ?  TrackerState.complete : TrackerState.disabled),
          Steps(title: Text("50%"), state: 10/2 <= listofRemainingLength ?  TrackerState.complete : TrackerState.disabled),
          Steps(title: Text("100%"), state: listofRemainingLength >= 10? TrackerState.complete :TrackerState.disabled),
        ],
      ),
    );
  }
}
