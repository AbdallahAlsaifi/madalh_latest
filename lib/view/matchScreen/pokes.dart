import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../../controllers/constants.dart';
import '../../controllers/systemController.dart';
import 'matchProfile.dart';
class pokeScreen extends StatefulWidget {
  final gender;
  final pokeSend;
  final pokeRec;
  const pokeScreen({Key? key, required this.gender, required this.pokeSend, required this.pokeRec}) : super(key: key);

  @override
  State<pokeScreen> createState() => _pokeScreenState();
}

class _pokeScreenState extends State<pokeScreen> {



  List PokeSent = [];
  List PokeRec = [];
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, (){
      setState(() {
        PokeSent = widget.pokeSend;
        PokeRec = widget.pokeRec;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: widget.gender == 'f'
        ? SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: constants.UserInfo(text: 'هنا تجد النكزات')),
            PokeSent.isNotEmpty == true
                ? ListView.builder(
              itemBuilder:
                  (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                              bottom: 0),
                          width:
                          constants.screenWidth *
                              0.9,
                          height:
                          constants.screenHeight *
                              0.15,
                          decoration: BoxDecoration(
                            gradient: Provider.of<
                                AppService>(
                                context,
                                listen:
                                false)
                                .systemGradient ==
                                constants.femaleG
                                ? constants.maleG
                                : constants.femaleG,
                            borderRadius:
                            BorderRadius.only(
                                topLeft: Radius
                                    .circular(10),
                                topRight: Radius
                                    .circular(
                                    10)),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                  EdgeInsets.all(
                                      5),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Icon(
                                        Bootstrap
                                            .person_fill,
                                        color: Colors
                                            .white,
                                        size: constants
                                            .screenWidth *
                                            0.2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AvatarGlow(
                                glowColor:
                                Colors.white,
                                endRadius: 60.0,
                                child: Material(
                                  // Replace this child with your own
                                  elevation: 8.0,
                                  shape:
                                  CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor:
                                    Colors.white,
                                    child: Icon(
                                      Bootstrap
                                          .heart_fill,
                                      color: Colors
                                          .redAccent,
                                    ),
                                    radius: constants
                                        .screenWidth *
                                        0.06,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            Material(
                              shadowColor:
                              Colors.black,
                              elevation: 2,
                              child: Container(
                                width: constants
                                    .screenWidth *
                                    0.9,
                                padding:
                                EdgeInsets.all(
                                    10),
                                decoration:
                                BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius
                                          .circular(
                                          10),
                                      bottomRight: Radius
                                          .circular(
                                          10)),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                        EdgeInsets
                                            .all(
                                            5),
                                        child: Text(
                                          'نسبة التطابق: ${PokeSent[index].data()['similarity']}%',
                                          style:
                                          TextStyle(
                                            color: Theme.of(context).primaryColor ==
                                                constants
                                                    .maleSwatch
                                                ? constants
                                                .peach1
                                                : constants
                                                .azure1,
                                            fontSize:
                                            constants.screenWidth *
                                                0.06,
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                          textDirection:
                                          TextDirection
                                              .rtl,
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed:
                                            () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId:
                                                PokeSent[index].data()['matchId'],
                                                userId:
                                                PokeSent[index].data()['recId'],
                                                similarityPercentage:
                                                PokeSent[index].data()['similarity'],
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'تم النكز',
                                          style:
                                          TextStyle(
                                            color: Colors
                                                .white,
                                            fontSize:
                                            constants.screenWidth *
                                                0.06,
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                          textDirection:
                                          TextDirection
                                              .rtl,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                );
              },
              itemCount: PokeSent.length,
              shrinkWrap: true,
            )
                : Center(
                  child: constants.smallText(
                  'لم تنكزي أحد إلى حد الأن', context,
                  color: Colors.redAccent),
                )
          ]),
    )
        : SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: constants.UserInfo(text: 'هنا تجد النكزات')),
            PokeRec.isNotEmpty
                ? ListView.builder(
              itemBuilder:
                  (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                              bottom: 0),
                          width:
                          constants.screenWidth *
                              0.9,
                          height:
                          constants.screenHeight *
                              0.15,
                          decoration: BoxDecoration(
                            gradient: Provider.of<
                                AppService>(
                                context,
                                listen:
                                false)
                                .systemGradient ==
                                constants.femaleG
                                ? constants.maleG
                                : constants.femaleG,
                            borderRadius:
                            BorderRadius.only(
                                topLeft: Radius
                                    .circular(10),
                                topRight: Radius
                                    .circular(
                                    10)),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                  EdgeInsets.all(
                                      5),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Icon(
                                        Bootstrap
                                            .person_fill,
                                        color: Colors
                                            .white,
                                        size: constants
                                            .screenWidth *
                                            0.2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AvatarGlow(
                                glowColor:
                                Colors.white,
                                endRadius: 60.0,
                                child: Material(
                                  // Replace this child with your own
                                  elevation: 8.0,
                                  shape:
                                  CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor:
                                    Colors.white,
                                    child: Icon(
                                      Bootstrap
                                          .heart_fill,
                                      color: Colors
                                          .redAccent,
                                    ),
                                    radius: constants
                                        .screenWidth *
                                        0.06,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            Material(
                              shadowColor:
                              Colors.black,
                              elevation: 2,
                              child: Container(
                                width: constants
                                    .screenWidth *
                                    0.9,
                                padding:
                                EdgeInsets.all(
                                    10),
                                decoration:
                                BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius
                                          .circular(
                                          10),
                                      bottomRight: Radius
                                          .circular(
                                          10)),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                        EdgeInsets
                                            .all(
                                            5),
                                        child: Text(
                                          'نسبة التطابق: ${PokeRec[index].data()['similarity']}%',
                                          style:
                                          TextStyle(
                                            color: Theme.of(context).primaryColor ==
                                                constants
                                                    .maleSwatch
                                                ? constants
                                                .peach1
                                                : constants
                                                .azure1,
                                            fontSize:
                                            constants.screenWidth *
                                                0.06,
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                          textDirection:
                                          TextDirection
                                              .rtl,
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed:
                                            () {
                                          navigateTo(
                                              ReuseableMatchProfile(
                                                matchId:
                                                PokeRec[index].data()['matchId'],
                                                userId:
                                                PokeRec[index].data()['senId'],
                                                similarityPercentage: PokeRec[index]
                                                    .data()['similarity']
                                                    .toDouble(),
                                              ),
                                              context);
                                        },
                                        child: Text(
                                          'تم نكزك',
                                          style:
                                          TextStyle(
                                            color: Colors
                                                .white,
                                            fontSize:
                                            constants.screenWidth *
                                                0.06,
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                          textDirection:
                                          TextDirection
                                              .rtl,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                );
              },
              itemCount: PokeRec.length,
              shrinkWrap: true,
            )
                : Center(
                  child: constants.smallText(
                  'لم تنكز من قبل اي احد  لحد الأن',
                  context),
                )
          ]),
    ),);
  }
}
