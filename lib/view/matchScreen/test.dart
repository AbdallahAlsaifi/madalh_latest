// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:madalh/controllers/constants.dart' as constants;
// import 'package:provider/provider.dart';
//
// import '../../controllers/constants.dart';
// import '../../controllers/systemController.dart';
// import 'matchProfile.dart';
//
// _sendQuestion(context, x) {}
//
// _sendContactInformation(context, x) {}
// FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Widget RequestContainer(index, int type) {
//   TextEditingController controller = TextEditingController();
//   if (type == 0) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.x_circle_fill,
//                     color: Colors.red,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'لقد رفضت هذا المستخدم',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   } else if (type == 1) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.pencil_square,
//                     color: Colors.orange,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار المستخدم لإجابة سؤالك',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Container(
//                     width: constants.screenWidth * 0.9,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         constants.smallText(
//                             'بإنتظار الإجابة على السؤال', context,
//                             color: Colors.red)
//                       ],
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   } else if (type == 2) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.check_circle_fill,
//                     color: Colors.green,
//                   ),
//                   Text(
//                     'تم إخفاء ملفك عن المستخدم و إرسال معلومات ولي الأمر إليه',
//                     style: TextStyle(color: Colors.green),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   } else if (type == 3) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.pencil_square,
//                     color: Colors.orange,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار المستخدم لإجابة سؤالك',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Container(
//                     width: constants.screenWidth * 0.9,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         constants.smallText(
//                             'بإنتظار الإجابة على السؤال', context,
//                             color: Colors.red)
//                       ],
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 4) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.pencil_square,
//                     color: Colors.orange,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار المستخدم لإجابة سؤالك',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Container(
//                     width: constants.screenWidth * 0.9,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         constants.smallText(
//                             'بإنتظار الإجابة على السؤال', context,
//                             color: Colors.red)
//                       ],
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 5) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.pencil_square,
//                     color: Colors.orange,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار المستخدم لإجابة سؤالك',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Container(
//                     width: constants.screenWidth * 0.9,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         constants.smallText(
//                             'بإنتظار الإجابة على السؤال', context,
//                             color: Colors.red)
//                       ],
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 6) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.clock,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'تم الرد على سؤالك',
//                     style: TextStyle(color: Theme.of(context).primaryColor),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Wrap(
//                 children: [
//                   constants.smallText(ReqRec[index]['answer']['answer'], context),
//                 ],
//             ),
//             Column(
//               children: [
//                 Divider(),
//                 Container(
//                     width: constants.screenWidth * 0.9,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         FilledButton(
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                 MaterialStateColor.resolveWith(
//                                         (states) => Colors.red)),
//                             onPressed: () {},
//                             child: Text('رفض')),
//
//                         FilledButton(
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                 MaterialStateColor.resolveWith(
//                                         (states) => Colors.green)),
//                             onPressed: () {
//                               _sendContactInformation(
//                                   context, ReqRec[index]['reqId']);
//                             },
//                             child: Text('قبول'))
//                       ],
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 7) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.pencil_square,
//                     color: Colors.red,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'لقد تم رفض سؤالك من قبل الإدارة، لديك فرصة أخيرة لسؤال آخر',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Wrap(
//               alignment: WrapAlignment.center,
//               children: [
//                 Text(
//                   ReqRec[index].data()!['question']['question'],
//                   style: TextStyle(color: Colors.red),
//                   textDirection: TextDirection.rtl,
//                 )
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.orange, width: 2)),
//               width: constants.screenWidth * 0.9,
//               child: TextField(
//                 controller: controller,
//                 minLines: 3,
//                 maxLines: 6,
//                 maxLength: 150,
//                 textDirection: TextDirection.rtl,
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'السؤال',
//                 ),
//               ),
//             ),
//             FilledButton(
//               onPressed: () async {
//                 await _firestore
//                     .collection('requests')
//                     .doc(ReqRec[index].data()!['reqId'])
//                     .update({
//                   'question': {
//
//                     'question': controller.text,
//                     'qApprove': -1
//                   },
//                   'recResType': 3,
//                 });
//               },
//               child: Text('ارسال'),
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateColor.resolveWith(
//                           (states) => Colors.orange)),
//             ),
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]
//                                               ['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]
//                                               ['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 8) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.pencil_square,
//                     color: Colors.orange,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار المستخدم لإجابة سؤالك',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Container(
//                     width: constants.screenWidth * 0.9,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         constants.smallText(
//                             'بإنتظار الإجابة على السؤال', context,
//                             color: Colors.red)
//                       ],
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 9) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.check_circle_fill,
//                     color: Colors.green,
//                   ),
//                   Text(
//                     'تم إخفاء معلومات ولي الأمر لمرسلة سابقا للمستخدم',
//                     style: TextStyle(color: Colors.green),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.clock,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'لديك طلب جديد بإنتظار ردك',
//                     style: TextStyle(color: Theme.of(context).primaryColor),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Container(
//                     width: constants.screenWidth * 0.9,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         FilledButton(
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                 MaterialStateColor.resolveWith(
//                                         (states) => Colors.red)),
//                             onPressed: () {},
//                             child: Text('رفض')),
//                         FilledButton(
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                 MaterialStateColor.resolveWith(
//                                         (states) => Colors.orange)),
//                             onPressed: () {
//                               _sendQuestion(context, ReqRec[index]['reqId']);
//                             },
//                             child: Text('إرسال سؤال')),
//                         FilledButton(
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                 MaterialStateColor.resolveWith(
//                                         (states) => Colors.green)),
//                             onPressed: () {
//                               _sendContactInformation(
//                                   context, ReqRec[index]['reqId']);
//                             },
//                             child: Text('قبول'))
//                       ],
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider.of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqRec[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqRec[index]
//                                               ['matchId'],
//                                               userId: ReqRec[index]['senId'],
//                                               similarityPercentage:
//                                               ReqRec[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }
// }
// Widget RequestContainer2(index, int type, context, ReqSent) {
//   TextEditingController controller = TextEditingController();
//   if (type == 0) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.x_circle_fill,
//                     color: Colors.red,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'لقد تم رفضك من قبل المستخدم',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   } else if (type == 1) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.clock,
//                     color: Theme
//                         .of(context)
//                         .primaryColor,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار رد المستخدمة على طلبك',
//                     style: TextStyle(color: Theme
//                         .of(context)
//                         .primaryColor),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   } else if (type == 2) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.check_circle_fill,
//                     color: Colors.green,
//                   ),
//                   Text(
//                     'تم إخفاء ملفك عن المستخدم و إرسال معلومات ولي الأمر إليه',
//                     style: TextStyle(color: Colors.green),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         Fluttertoast.showToast(
//                                             msg: 'لقد تم إخفاء ملف المستخدم للخصوصية، وسيتم اخفاء معلومات ولي الأمر خلال 4 ايام');
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   } else if (type == 3) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.clock,
//                     color: Theme
//                         .of(context)
//                         .primaryColor,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار رد المستخدمة على طلبك',
//                     style: TextStyle(color: Theme
//                         .of(context)
//                         .primaryColor),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 4) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.clock,
//                     color: Theme
//                         .of(context)
//                         .primaryColor,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار رد المستخدمة على طلبك',
//                     style: TextStyle(color: Theme
//                         .of(context)
//                         .primaryColor),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 5) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.pencil_square,
//                     color: Colors.orange,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'لقد تم سؤالك من قبل المستخدم وعلى حسب الإجابة سيتم القبول او الرفض من قبل المستخدم',
//                     style: TextStyle(color: Colors.orange),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Wrap(
//               alignment: WrapAlignment.center,
//               children: [
//                 Text(
//                   ReqSent[index].data()!['question']['question'],
//                   style: TextStyle(color: Colors.orange),
//                   textDirection: TextDirection.rtl,
//                 )
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.orange, width: 2)),
//               width: constants.screenWidth * 0.9,
//               child: TextField(
//                 controller: controller,
//                 minLines: 3,
//                 maxLines: 6,
//                 maxLength: 150,
//                 textDirection: TextDirection.rtl,
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'الإجابة',
//                 ),
//               ),
//             ),
//             FilledButton(
//               onPressed: () async {
//                 await _firestore
//                     .collection('requests')
//                     .doc(ReqSent[index].data()!['reqId'])
//                     .update({
//                   'answer': {
//
//                     'answer': controller.text,
//                     'aApprove': -1
//                   },
//                   'recResType': 4,
//                 });
//               },
//               child: Text('ارسال'),
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateColor.resolveWith(
//                           (states) => Colors.orange)),
//             ),
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]
//                                               ['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]
//                                               ['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 6) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.clock,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'تم ارسال اجابتك الى المستخدمة، بإنتظار ردها',
//                     style: TextStyle(color: Theme.of(context).primaryColor),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]
//                                               ['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]
//                                               ['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 7) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.clock,
//                     color: Theme
//                         .of(context)
//                         .primaryColor,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار رد المستخدمة على طلبك',
//                     style: TextStyle(color: Theme
//                         .of(context)
//                         .primaryColor),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 8) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.pencil_square,
//                     color: Colors.red,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'تم رفض إجابتك من قبل الإدارة و لديك فرضة اخيرة للإجابة، لقد تم سؤالك من قبل المستخدم وعلى حسب الإجابة سيتم القبول او الرفض من قبل المستخدم',
//                     style: TextStyle(color: Colors.red),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Wrap(
//               alignment: WrapAlignment.center,
//               children: [
//                 Text(
//                   ReqSent[index].data()!['question']['question'],
//                   style: TextStyle(color: Colors.orange),
//                   textDirection: TextDirection.rtl,
//                 )
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.orange, width: 2)),
//               width: constants.screenWidth * 0.9,
//               child: TextField(
//                 controller: controller,
//                 minLines: 3,
//                 maxLines: 6,
//                 maxLength: 150,
//                 textDirection: TextDirection.rtl,
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'الإجابة',
//                 ),
//               ),
//             ),
//             FilledButton(
//               onPressed: () async {
//                 await _firestore
//                     .collection('requests')
//                     .doc(ReqSent[index].data()!['reqId'])
//                     .update({
//                   'answer': {
//
//                     'answer': controller.text,
//                     'aApprove': -1
//                   },
//                   'recResType': 4,
//                 });
//               },
//               child: Text('ارسال'),
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateColor.resolveWith(
//                           (states) => Colors.orange)),
//             ),
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]
//                                               ['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]
//                                               ['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }else if (type == 9) {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.check,
//                     color: Colors.green,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'تم اخفاء المعلومات',
//                     style: TextStyle(color: Colors.green),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Wrap(
//               alignment: WrapAlignment.center,
//               children: [
//                 Text(
//                   'عندما تتعدى معلومات المستخدم 4 ايام يتم اخفاء معلومات المستخدم لذا تم إخفاء معلومات المستخدم لضمان الخصوصية',
//                   style: TextStyle(color: Colors.orange),
//                   textDirection: TextDirection.rtl,
//                 )
//               ],
//             ),
//
//           ],
//         ));
//   }else {
//     return Container(
//         margin: EdgeInsets.only(top: 5),
//         child: ExpansionTileCard(
//           title: Container(
//               width: constants.screenWidth * 0.9,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   Icon(
//                     Bootstrap.clock,
//                     color: Theme
//                         .of(context)
//                         .primaryColor,
//                   ),
//                   Container(
//                     width: 5,
//                   ),
//                   Text(
//                     'بإنتظار رد المستخدمة على طلبك',
//                     style: TextStyle(color: Theme
//                         .of(context)
//                         .primaryColor),
//                     textDirection: TextDirection.rtl,
//                   )
//                 ],
//               )),
//           children: [
//             Column(
//               children: [
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 10, right: 10, bottom: 0),
//                       width: constants.screenWidth * 0.9,
//                       height: constants.screenHeight * 0.15,
//                       decoration: BoxDecoration(
//                         gradient:
//                         Provider
//                             .of<AppService>(context, listen: false)
//                             .systemGradient ==
//                             constants.femaleG
//                             ? constants.maleG
//                             : constants.femaleG,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Bootstrap.person_fill,
//                                     color: Colors.white,
//                                     size: constants.screenWidth * 0.2,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           AvatarGlow(
//                             glowColor: Colors.white,
//                             endRadius: 60.0,
//                             child: Material(
//                               // Replace this child with your own
//                               elevation: 8.0,
//                               shape: CircleBorder(),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Bootstrap.heart_fill,
//                                   color: Colors.redAccent,
//                                 ),
//                                 radius: constants.screenWidth * 0.06,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Material(
//                           shadowColor: Colors.black,
//                           elevation: 2,
//                           child: Container(
//                             width: constants.screenWidth * 0.95,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(5),
//                                     child: FittedBox(
//                                       child: Text(
//                                         'نسبة التطابق: ${ReqSent[index]['similarity']}%',
//                                         style: TextStyle(
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor ==
//                                               constants.maleSwatch
//                                               ? constants.peach2
//                                               : constants.azure1,
//                                           fontSize:
//                                           constants.screenWidth * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   ),
//                                   FittedBox(
//                                     child: FilledButton(
//                                       onPressed: () {
//                                         navigateTo(
//                                             ReuseableMatchProfile(
//                                               matchId: ReqSent[index]
//                                               ['matchId'],
//                                               userId: ReqSent[index]['senId'],
//                                               similarityPercentage:
//                                               ReqSent[index]['similarity']
//                                                   .toDouble(),
//                                             ),
//                                             context);
//                                       },
//                                       child: Text(
//                                         'عرض الملف',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize:
//                                           constants.screenWidth * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textDirection: TextDirection.rtl,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ],
//         ));
//   }
// }