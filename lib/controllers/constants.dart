import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:madalh/controllers/systemController.dart';
import 'package:madalh/homePage.dart';
import 'package:madalh/main.dart';
import 'package:provider/provider.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

const azure1 = Color(0xff7A76FF);
const azure2 = Color(0xff74FEBD);
const maleG = LinearGradient(colors: [azure1, azure2]);
const maleGO = LinearGradient(colors: [azure2, azure1]);

const peach1 = Color(0xffF256FD);
const peach2 = Color(0xfff8d5e4);
const landingColor = Color(0xffBA8ED4);
const femaleG = LinearGradient(colors: [peach1, peach2]);
const femaleGO = LinearGradient(colors: [peach2, peach1]);

commitChanges(WriteBatch x) async {
  try {
    await x
        .commit()
        .whenComplete(() => debugPrint('Complete'))
        .onError((error, stackTrace) => debugPrint(error.toString()));
  } catch (e) {
    debugPrint(e.toString());
  }
}

updateCategory(category) async {
  List<String> cat = [category];
  await firestore
      .collection('musers')
      .doc(auth.currentUser!.uid)
      .update({'completedCat': FieldValue.arrayUnion(cat)});
}

// showCongratsDialog(context, msg) {
//   return showDialog(context: context, builder: (BuildContext context) {
//     return AlertDialog(content: Container(
//       width: screenWidth * 0.95, height: screenHeight * 0.9, child: Scaffold(
//       bottomNavigationBar: Container(
//         width: screenWidth, height: screenHeight * 0.2, child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: longButton('المتابعة', context,
//                 buttonColor: Theme
//                     .of(context)
//                     .primaryColor),
//           ),
//         ],
//       ),),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Image.asset('assets/videos/party1.gif'),
//             Container(
//               width: screenWidth * 0.9,
//               height: screenHeight * 0.2,
//               child: Image.asset(
//                 'assets/videos/party3.gif', fit: BoxFit.cover,),),
//             Wrap(
//               alignment: WrapAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: smallText(msg, context, color: Colors.red),
//                 ),
//               ],
//             )
//
//           ],
//         ),
//       ),
//     ),),);
//   },);
// }
void MsgDialog(BuildContext context, Msg) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(''),
      content: Text(
        '${Msg.replaceAll('firebase', '').replaceAll('Firebase', '').replaceAll('Firestore', '').replaceAll('firestore', '')}',
      ),
      actions: [

        FilledButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context, 'User canceled dialog'),
        ),
      ],
    ),
  );

}
setBatch({
  required WriteBatch batch,
  required questionId,
  required question,
  required ans,
  required images,
  required cat,
  required type,
  status = 1,
}) {
  batch.set(
      firestore
          .collection('answers')
          .doc(auth.currentUser!.uid)
          .collection('answers')
          .doc(questionId),
      {
        "question": question,
        "answer": ans,
        "uid": questionId,
        'date': DateTime.now(),
        "Images": images,
        "cat": cat,
        'type': type,
        "status": status,
      },
      SetOptions(merge: true));
}

final ListOfCountries = [
  'فلسطين',
  'الأردن',
  'خارج فلسطين و الأردن',
];
final pcities = [
  'القدس',
  'أريحا',
  'الخليل',
  'بيت لحم',
  'جنين',
  'رام الله والبيرة',
  'سلفيت',
  'طوباس',
  'طولكرم',
  'الوزارة/ غزة',
  'قلقيلية',
  'نابلس',
  'دير البلح',
  'خانيونس',
  'رفح',
  'شمال غزة',
  'الداخل',
'غير ذلك'
];
final scities = [
  'دمشق',
  'حلب',
  'حمص',
  'الجولان',
  'درعا',
  'الشام'
  'حماة',
  'اللاذقية',
  'دير الزور',
  'الرقة',
  'إدلب',
  'طرطوس',
  'تدمر',
  'القامشلي',
  'السويداء',
  'الحسكة',
  'القنيطرة',
  'مصياف',
  'الرستن',
  'صلنفة',
  'الباب',
  'المالكية',
  'المرج',
  'البوكمال',
  'عفرين',
  'معرة النعمان',
  'سلمية',
  'الزبداني',
  'عين العرب',
  'السخنة',
  'حلب الجديدة',
  'القدموس',
  'سراقب',
  'المليحة',
  'المزيريب',
  'عين الفيجة',
  'تل أبيض',
  'منبج',
  'معرة مصرين',
  'غير ذلك'
];

final jcities = [
  'عمّان',
  'إربد',
  'الزرقاء',
  'السلط',
  'المفرق',
  'الكرك',
  'مادبا',
  'جرش',
  'عجلون	',
  'العقبة',
  'معان',
  'الطفيلة',
  'غير ذلك'
];
final lcities = [
  'بيروت',
  'طرابلس',
  'صيدا',
  'زحلة',
  'جونية',
  'جبيل',
  'بعلبك',
  'النبطية',
  'صور',
  'عاليه',
  'بعبدا',
  'الزلقا',
  'المتن',
  'البترون',
  'البقاع الغربي',
  'الشوف',
  'بشري',
  'راشيا',
  'الحمانا',
  'حاصبيا',
  'الناقورة',
  'المرج',
  'القبيات',
  'عكار',
  'المية ومية',
  'الخيام',
  'المكلس',
  'العبادية',
  'تعلبايا',
  'الغازية',
  'بنت جبيل',
  'الدوير',
  'الريحانية',
  'دير القمر',
  'جزين',
  'الرملة',
  'غير ذلك'
];

final palestineAreas = {
  'القدس': [
    'السَواحِرَة الشَرْقِيَّة',
    'العِيْزَرِيَّة',
    'بِدُّو',
    'بِيت سُورِيك',
    'بِير نَبَالا',
    'عَناتَا',
    'قَطَنَّة',
    'الجِيْب',
    'الزْعَيِّمْ',
    'الشَيْخ سَعْد',
    'النَبِي صَمُوئيل',
    'بِيت إكْسَا',
    'بِيت حَنِينَا البَلَد',
    'جَبَعْ',
    'خَرائِب أمُّ اللَحْمْ',
    'رَافَات',
    'قَلَنْدِيَا',
    'كَفْر عَقَب',
    'مِخْمَاس',
    'ابو دِيس',
    'عرب الجَهَالين (سلامات)',
    'الرَام وضَاحِيَة البَريد',
    'بِيت عَنَان',
    'القُبَيْبَة',
    'بِيت إجْزَا',
    'الخان الأحمر',
    'الجُدَيْرَة',
    'بِيت دُقُّو',
    'حِزْما',
  ],
  'أريحا': [
    'أريحا',
    'النُوَيْعِمَة وعِيْن الدْيوك الفُوقا',
    'الجِفْتْلِك',
    'فَصَايِل',
    'مَرْج الغَزال',
    'مَرْج نَعْجَة',
    'الزُبَيْدات',
    'العوجَا',
  ],
  'الخليل': [
    'إدقيقة',
    'الخَليل',
    'السَمُوع',
    'الشُيُوخ',
    'إذْنَا',
    'بِيت أُولا',
    'بِيت أُمّر',
    'تَرْقُومْيا',
    'تَفُّوح',
    'خَارَاس',
    'دُورَا',
    'سَعِيْر',
    'صُورِيف',
    'خِرْبِة الدِير',
    'إمنيزل',
    'رابود وابو العرقان',
    'البُرْج، البيرة، بِيت مِرْسِم',
    'الرَماضِين',
    'الصُرَّة',
    'الكَرْمِل',
    'المَجْد',
    'بِيت عَمْرَة',
    'بيت كاحل',
    'خُرَسا',
    'دِير العَسَل الفُوقا',
    'شُيُوخْ العَرُّوب',
    'كَرْمَة',
    'نُوبَا',
    'التَوانِي',
    'حَتَّا',
    'دِير العَسَل التَحْتَا',
    'إمرِيش، عَبْدَة، العلقتين',
    'سِكَّة وطَوَاس',
    'سوسيا',
    'أُم الخير',
    'الكعابنه - أم الدرج (الزُوَيْدين)',
    'خَشْم الدرج (الهذالين)',
    'النَجادَة - الكعابنة',
    'بِيت الرُوشْ الفُوقا',
    'الكُوم',
    'دِير سَامِت',
    'بِيريِن',
    'مسافر يَطَّا',
    'خِرْبِة زَنُّوتَة',
    'خَشْم الكَرْم',
    'خربة أم الخير',
    'أبو العسجا ، أبو الغزلان',
    'بَني نَعِيم',
    'يَطَّا',
    'حَدَبْ ألفَوَّار',
    'خَلِّةْ المَيِّة',
    'بِيت الرُوشْ التَحْتَا',
    'وادي الشَاجِنَة، دِير رَازِح،طَرَّامَة، حفاير بسم',
    'بِيت عَوَّا',
    'الظَاهِرِيَّة',
    'حَلْحُول',
    'الرِيحِيَّة',
    'كرزة',
  ],
  'بيت لحم': [
    'الخَضِر',
    'العُبَيْدِيَّة',
    'بِيت فَجَّار',
    'بِيت لَحْم',
    'تُقُوع',
    'جناتا (بدَّ فلوح)',
    'زَعْتَرَة',
    'الجَبْعَة',
    'الشَوَاوْرَة',
    'المَعْصَرَة',
    'إرْطَاس',
    'بِيت تَعْمَر',
    'جْورَة الشَمْعَة',
    'حُوسَان',
    'دار صلاح',
    'عَرَبْ الرَشايْدِة',
    'مَرَاح رَبَاح',
    'مَراح مَعَلاَّ',
    'خَلِّةْ سَكَارْيَا',
    'وادي النِيصْ',
    'وادي رَحَّال',
    'الخَاص',
    'خَلِّة الحَدَّادْ',
    'كِيسَان',
    'خَلَّة النُعْمَان',
    'المَنْشِيَّة',
    'الدْوحَة',
    'بِيت جَالا',
    'الوَلَجَة',
    'أُمُّ سَلْمُونَة',
    'بَتِّير',
    'بيت ساحور',
    'هِنْدَازَة وبُرَيْضِعَة',
    'وادي فُوكِين',
    'نَحَّالين',
    'المَنِيِّا',
  ],
  'جنين': [
    'اليَامُون',
    'بِرْقين',
    'جنين',
    'سيلَةْ الحارِثِيَّة',
    'قَباطْيَة',
    'كَفْر رَاعي',
    'الطَيْبَة',
    'الفَنْدَقُومِيَّة',
    'تِلْفِيت',
    'ظَهْر المَالِح',
    'فَحْمَة الجَدِيدَة',
    'كَفْر قُود',
    'بير الباشا',
    'رابا',
    'رُمَّانَة',
    'صانور',
    'فَحْمَة',
    'كفر دان',
    'كُفَيْرِتْ',
    'مِرْكَة',
    'مِسِلْيَة',
    'أمُّ التوت',
    'أُمُّ الرِيحَان',
    'أُمُّ دار',
    'العَرَقَة',
    'بَرْطَعَة الشَرْقِيَّة',
    'عَانِين',
    'عَجِّة',
    'عَنْزَة',
    'خِرْبِة عَبْدَ الله اليونِس',
    'عَرَّابَة',
    'يَعْبَدْ',
    'ظَهْر العَبْد',
    'الكُفَيْر',
    'نَزْلَة الشَيْخ زَيْد',
    'تِعِنِّك',
    'الرامَة',
    'العَصاعْصَة',
    'الجُدَيِّدَة',
    'سِيرِيس',
    'فَقُّوعَة',
    'مَيْثَلون',
    'دِير ابو ضَعيف',
    'الجَلَمَة',
    'مَشْروع بِيت قاد (الشَمَالي)',
    'بِيت قاد (الجَنُوبي)',
    'دِير غَزالَة',
    'فراسين',
    '( واد الضبع ( عابة الشرقية',
    'الحَفِيرَة (حَفِيرَة عَرَّابَة)',
    'وادي دْعُوق',
    'الخُلْجان',
    'جَبَعْ',
    'الشُهَداء (مثلث الشُهَداء)',
    'الزَبابِدَة',
    'الزاوِيَة',
    'طورَة',
    'صِير',
    'عَرَبُّونَة',
    'سيلَة الظَهْر',
    'المُغيِّر',
    'جَلْقَمُوس',
    'زبوبا',
    'الهاشِمِيَّة',
    'العطَّارَة',
    'زَبْدَة الجديدة',
    'عَرَّانَة',
    'جَلْبُون',
    'المُطِلَّة',
    'المَنْصورَة',
  ],
  'رام الله والبيرة': [
    'صُرْدَا وأبو قَشّ',
    'رَوابي',
    'جِيْبيا',
    'خِرْبَةْ أبو فَلاَحّ',
    'خَرْبَثا المِصْباح',
    'دُورا القَرِع',
    'البِيرَة',
    'المَزْرَعَة الشَرْقِيَّة',
    'بَني زِيْد (الغربية)',
    'بيت لقيا',
    'بِيتُونْيا',
    'بِيرزيت',
    'تُرْمُسعَيَّا',
    'دِير دُبْوَان',
    'رامَ الله',
    'سِنْجِل',
    'عِبْوَيْن',
    'نِعْلِين',
    'الطيرَة',
    'اللُبَّنْ الغَرْبي',
    'المُغَيِّر',
    'النَبي صالِح',
    'بُرْقَة',
    'بُرْهَام',
    'بِلْعِين',
    'بِيت سِيرَا',
    'بِيت عُوْر الفُوقَا',
    'بَيْتِين',
    'جِفْنَا',
    'جِلْجِيلِيَّا',
    'دِير السُودَان',
    'دِير أبو مَشْعَلْ',
    'دِير جَرِيْر',
    'دِير قِدِّيس',
    'دِير نِظَام',
    'رَمُّون',
    'رَنْتِيس',
    'شُقْبَا',
    'عابُود',
    'عَجُّول',
    'عِيْن سِينْيا',
    'عِيْن عَرِيك',
    'عِيْن قِينيا',
    'عين يبرود',
    'قِبْيَا',
    'قَرَاوَة بَني زِيْد',
    'كَفْر عِيْن',
    'كَفْر مَالِك',
    'كُوبَر',
    'يَبْرُود',
    'أمُّ صَفَا',
    'ابو شُخَيْدِم',
    'المَزْرَعَة القِبْلِيَّة',
    'بِيتِللُّو',
    'جَمَّالا',
    'دِير عَمَّار',
    'عارُورَة',
    'خَرْبَثا بَنِي حَارِث',
    'سِلْواد',
    'عَطَارَة',
    'دِير إبزِيع',
    'رَاس كَرْكَرْ',
    'كَفْر نِعْمَة',
    'مزارع النوباني',
    'الطَيْبَة',
    'الجانِيَة',
    'المِدْيَة',
    'بُدْرُس',
    'بِيت عُوْرْ التَحْتَا',
    'شِبْتِين',
    'صَفَّا',
  ],
  'سلفيت': [
    'بِدْيَا',
    'بْرُوقِين',
    'دِير إستْيا',
    'دِير بَلُّوط',
    'سَلْفِيت',
    'قَراوَة بَني حَسَّان',
    'كِفِلْ حَارِس',
    'سَرْطَة',
    'حَارِس',
    'رَافات',
    'قِيرَة',
    'مَرْدَا',
    'يَاسُوف',
    'كَفْر الدِيك',
    'إسْكَاكَا',
    'فَرْخَة',
    'الزَاوِيَة',
    'مَسْحَة',
  ],
  'طوباس': [
    'طَمُّون',
    'عَقَّابَا',
    'العَقَبَة',
    'تَياسِير',
    'عِيْن البَيْضَا',
    'خِرْبِة عَاطُوف',
    'كَرْدَلَة',
    'رَاس الفارْعَةْ',
    'إبْزِيق',
    'خِرْبِة يَرْزَة',
    'طُوبَاس',
    'بَرْدَلَة',
    'وادي الفارِعَة',
    'المالح',
  ],
  'طولكرم': [
    'دِير الغُصُون',
    'زَيْتَا',
    'طُولكَرْم',
    'عَنَبْتا',
    'قَفِّين',
    'خِرْبَة جْبارة',
    'النَزْلَة الشَرْقيِّة',
    'رَامِين',
    'سَفَّارِين',
    'صَيْدا',
    'بَلْعا',
    'عَتِّيل',
    'فَرْعُون',
    'كَفْر زِيبَاد',
    'كَفْر صُور',
    'كُورْ',
    'الرَاس',
    'الجاروشِيَّة',
    'النَزْلَة الوُسطى',
    'النَزْلَة الغَرْبيِّة',
    'باقَة الشَرْقيِّة',
    'كَفْر اللَبَد',
    'إكتَابَا',
    'شُوفَة',
    'عِلاَّر',
    'عَكَّابَة',
    'بِيت لِيد',
    'كَفْر جَمَّال',
    'كَفْر عَبُّوش',
    'نَزْلَة عِيسى',
  ],
  'الوزارة/ غزة': [
    'المُغْراقَه',
    'جُحْر الدِيك',
    'غزّة',
    'مدينة الزهراء',
  ],
  'قلقيلية': [
    'جَيُّوس',
    'حَبْلَة',
    'قَلْقِيلْيَة',
    'كَفْر ثُلْث',
    'النَبِي إليَاس',
    'بِيت أَمين',
    'جِنْصَافُوط',
    'حَجَّة',
    'سَنّيرْيَا',
    'كَفْر لاقِف',
    'فَلامِية',
    'عَزُّون',
    'راس عَطِيَّة',
    'عَزُّون عَتْمَة',
    'عَرَب الرَماضِين الجَنُوبي',
    'عَرَب الرَماضِين الشَمَالي',
    'الفُنْدُق',
    'عَسْلَة',
    'خِرْبِة صِيْر',
    'فَرْعَتا',
    'الضَبْعَة',
    'باقَةْ الحَطَب',
    'جِيْت',
    'كَفْر قَدُّوم',
    'عَرَب أبو فَرْدَة',
    'العزب الغربي',
    'إِمَّاتِين',
  ],
  'نابلس': [
    'بِيتَا',
    'حُوَّارَة',
    'عَقْرَبَا',
    'قَبَلان',
    'البَاذَان',
    'السَاوِيَة',
    'النَصَّارِيَّة',
    'أللُبَّنْ الشَرْقِيَّة',
    'أُوصَرِين',
    'بُرْقَة',
    'بُورِين',
    'بِيت إِمرِين',
    'بِيت حَسَن',
    'بِيت دَجَن',
    'تِلّ',
    'تَلْفِيت',
    'جُورِيش',
    'دُوْمَا',
    'دِير الحَطَب',
    'دِير شَرَفْ',
    'رُوجِيب',
    'سالِم',
    'صَرَّة',
    'فُرُوش بِيت دَجَن',
    'جَالُود',
    'قُصْرة',
    'قُوصِين',
    'مَادَما',
    'مَجْدَلْ بَني فاضِل',
    'يِتْمَا',
    'جَمَّاعِين',
    'العَقْرَبانِيَّة',
    'زَيْتَا جَمَّاعِين',
    'عَزْمُوط',
    'عَصِيرَة القِبْلِيَّة',
    'عَوَرْتا',
    'عُورِيف',
    'عِيْن شِبْلِي',
    'عَيْنَبُوس',
    'نِصْف جُبَيْل',
    'إجْنِسِنْيَا',
    'عَمُّورْيَة',
    'نابْلُس',
    'الناقُورَة',
    'أُودَلاَ',
    'زَوَاتا',
    'طَلُّوزة',
    'عِرَاق بُورِين',
    'بِيت فُورِيك',
    'سَبَسْطِية',
    'بَزَّارْيَة',
    'بِيت إيبَا',
    'بِيت وَزَنْ',
    'قَرْيُوت',
    'كَفْر قَلِّيل',
    'ياصيد',
    'عَصيرَة الشماليَّة',
  ],
  'دير البلح': [
    'البُرَيْج',
    'الزَوايْدَة',
    'المُصَدَّر',
    'المَغَازِي',
    'النُصَيْرَات',
    'دِير البَلح',
    'وادِي السَلْقَا',
  ],
  'خانيونس': [
    'الفُخَّارِي',
    'القَرَارَة',
    'بَنِي سُهِيلا',
    'خانيونس',
    'خُزَاعَة',
    'عَبَسَان الجَديدَة',
    'عَبَسَان الكَبِيرَة',
  ],
  'رفح': [
    'النصر',
    'الشُوكَة',
    'رَفَح',
  ],
  'شمال غزة': [
    'أم النصر (القَريَة البَدَوِيَّة)',
    'بِيت حَانُون',
    'بِيت لاهْيا',
    'جَبَاليا',
  ],
  'الداخل': ['الداخل']
};
final hoppies = [
  'كرة اليد',
  'كرة القدم ',
  'كرة سلة',
  'كرة الطائرة',
  'التنس',
  'الجولف',
  'المشي',
  'الجري',
  'اليوجا',
  'السباحة',
  'التزلج على الجليد',
  'كرة القدم الأمريكية',
  'رمي السهام',
  'البولينج',
  'الهوكي',
  'الهوكي الجليدي',
  'البيسبول',
  'تسلق الجبال',
  'الرقص',
  'الكاراتيه',
  'سباق الخيل',
  'ركوب الدراجات',
  'الرماية',
  'صيد السمك',
  'التايكوندو',
  'الجودو',
  'الكيك بوكسينج',
  'الكونغ فو',
  'الجمباز',
  'رفع الأثقال',
  'الرسم',
  'الرسم بالألوان المائية',
  'الكتابة',
  'صنع البطاقات',
  'صنع أكاليل من الزهور',
  'صنع اللوحة الاكريليك',
  'النحت',
  'الحرف اليدوية مثل التريكو والكروشيه',
  'حرق الأخشاب',
  'الطلاء',
  'الرسم على الزجاج',
  'تلوين الزجاج',
  'صنع الصابون وتغليف الصابون',
  'صنع الشموع',
  'فن قص وتشكيل الورق',
  'كتابة النثر',
  'كتابة الشعر',
  'تصميم الرسومات',
  'تصميم الطابعات المجانية',
  'تصميم الشعارات والبطاقات وحقائب اليد وغيرها',
  'صناعة المجوهرات',
  'مصنوعات من الطين',
  'صنع الفخار / السيراميك',
  'فن المكياج',
  'تصفيف الشعر',
  'التصوير',
  'الخياطة',
  'التطريز',
  'تزيين المنزل',
  'التمثيل',
  'صنع ماسك الأحلام',
  'فن الرسم على القماش',
  'تصميم الأزياء',
  'طلاء الصخور',
  'صنع الدمى',
  'جمع الملصقات',
  'القراءة',
  'تزيين مخطط',
  'الكلمات المتقاطعة',
  'سودوكو',
  'تعلم لغة جديدة',
  'التخطيط للسفر والسفر',
  'تدوين الملاحظات والبحث',
  'دروس على الإنترنت',
  'التطوع',
  'ألعاب التفكير',
  'الاستماع إلى البودكاست',
  'إنشاء بودكاست',
  'جمع الاقتباس',
  'الغناء',
  'تعلم العزف على الجيتار',
  'العزف على البيانو',
  'العزف على الطبول',
  'تعلم العزف على الكمان',
  'العزف على التشيلو',
  'العزف على الناي',
  'تعلم العزف على البوق',
  'الانضمام إلى فرقة',
  'تعلم كيفية قراءة الموسيقى',
  'تعلم كتابة كلمات الأغاني',
  'حضور حفلة موسيقية وتصويرها',
  'الإستماع إلى أغاني',
  'حفظ كلمات الموسيقى',
  'التعرف على الموسيقيين',
  'أنواع الموسيقى المختلفةبطاقات البيسبول',
  'تذاكر الأحداث الرياضية',
  'قمصان رياضية أو تذكارات أخرى',
  'كتب رياضية',
  'الصور الموقعة أو غيرها من العناصر',
  'الكرات أو المعدات الرياضية',
  'بطاقات بريدية',
  'تذكارات دينية',
  'تذكارات تاريخيةالطبخ',
  'الخبز',
  'صناعة الكوكتيلات',
  'إنشاء مدونة طعام أو شراب',
  'ألعاب على الانترنت',
  'سودوكو',
  'حل الألغاز',
  'ألغاز ثلاثية الأبعاد',
  'لعب الورق',
  'لعبة الأفلام',
  'ألعاب الطاولة الأخرى',
  'ألعاب الكلمات والألغاز',
  'ألعاب الكترونية',
  'طباعة ثلاثية الابعاد',
  'جمع قصاصات الصحف',
  'صيانة الجوالات',
  'هواية العناية بالحيوانات',
  'هواية اللاسلكي',
  'بريك دانس',
  'صنع التروس',
  'التلوين',
  'البرمجة',
  'لغة مصطنعة',
  'الطبخ',
  'كوزبلاي',
  'الكتابة الإبداعية',
  'الكروشيه',
  'الرقص',
  'التطريز',
  'كرة القدم الخيالية',
  'العناية بأسماك الزينة',
  'تعلماللغات الأجنبية',
  'ممارسة لعبة تقمص الأدوار',
  'علم الأنساب',
  'علم الأنساب الجينية',
  'هواية تربية الزواحف والبرمائيات',
  'تصوير الأفلام المنزلية',
  'صنع المجوهرات',
  'ألعاب الخفة',
  'تشذيب الحجارة',
  'الحياكة',
  'صناعة المخرمات',
  'صقل الحجارة الكريمة',
  'أشغال الجلود اليدوية',
  'اللعب بالليغو',
  'فن الوهم',
  'آلة موسيقية',
  'فن طي الورق (أوريغامي)',
  'تصوير (فنون تشكيلية)',
  'تنس الطاولة',
  'فخار',
  'تضريب اللحف',
  'القراءة',
  'النحت',
  'الخياطة',
  'الماكياج',
  'الغناء',
  'صنع الصابون',
  'تحنيط الحيوانات',
  'ألعاب الفيديو',
  'الحفر على الخشب',
  'مشغولات خشبية',
  'بناء عالم',
  'الكتابة',
  'ممارسة اليوجا',
  'اللعب باليويو',
  'هوايات يمكن ممارستها في الخارج',
  'ممارسة الرياضات الهوائية',
  'حزم حقائب الظهر',
  'كرة القاعدة',
  'كرة السلة',
  'تربية النحل',
  'مراقبة الطيور',
  'بونساي',
  'القفز بالحبال',
  'التخييم',
  'كانو-كاياك',
  'كوزبلاي',
  'ركوب الدراجات',
  'قيادة مركبات',
  'زراعة الحدائق',
  'هواية العثور على المخابئ',
  'جرافيتي',
  'تجوال',
  'هولا هوب',
  'صيد',
  'الركض',
  'كانو-كاياك',
  'التزلج الشراعي',
  'صناعة الطائرات الورقية واللعب بها',
  'لعبة تمثيل الأدوار الحية',
  'تشغيل آلي (صناعة معدنية)',
  'التنقيب عن المعادن',
  'رياضة المحركات الآلية',
  'ركوب الدراجات في الجبال',
  'البحث عن الفطر أو علم الفطريات',
  'باركور',
  'تصوير',
  'تسلق الجبال',
  'التزلج بالعجلات',
  'الرغبي (رياضة)',
  'الركض',
  'سباق القوارب الشراعية',
  'بناء القلاع الرملية',
  'التجديف',
  'التزلج على الجليد',
  'الهبوط بالمظلات',
  'ركمجة',
  'التزلج على الثلوج',
  'السباحة',
  'تاي تشي شوان',
  'الاستكشاف الحضري',
  'رياضات مائية',
  'هوايات التجميع',
  'اثر',
  'مقتنيات خاصة',
  'جمع الكتب',
  'جمع البطاقات',
  'جمع العملات',
  'جمع طوابع البريد',
  'جيولوجيا للهواة',
  'الكتب القديمة',
  'السيارات القديمة',
  'الملابس القديمة',
  'آثار',
  'فن صناعة لوحات الزهور المجففة',
  'جمع الحشرات',
  'فن صناعة لوحات الزهور المجففة',
  'كاشف المعادن',
  'موازنة الصخور',
  'زجاج البحر',
  'الأصداف',
  'هوايات المنافسة',
  'هواية العناية بالحيوانات',
  'الريشة الطائرة',
  'البلياردو',
  'البولينج',
  'الملاكمة',
  'بريدج',
  'التشجيع',
  'الشطرنج',
  'الرقص',
  'المرماة',
  'مبارزة سيف الشيش',
  'غو',
  'الجمباز',
  'كرة زجاجية (لعبة)',
  'الفنون القتالية',
  'البوكر',
  'البرمجة',
  'طاولة كرة قدم',
  'كرة طائرة',
  'تدريب بالأثقال',
  'إير سوفت',
  'كرة القدم الأمريكية',
  'النبالة',
  'لعبة كرة القدم',
  'دوري كرة القدم الأسترالية',
  'سباق سيارات',
  'كرة القاعدة',
  'كرة السلة',
  'التسلق داخل الصالات المغلقة',
  'الكريكت',
  'ركوب الدراجات',
  'غولف القرص',
  'رياضة الكلاب',
  'فروسية',
  'هوكي الحقل',
  'تزلج فني على الجليد',
  'صيد السمك',
  'كرة قدم',
  'الجولف',
  'كرة اليد',
  'هوكي الجليد',
  'الجودو',
  'كارتينغ',
  'كرة الطلاء',
  'سباق الحمام',
  'كرة الراح',
  'رولر ديربي',
  'دوري الرغبي',
  'الركض',
  'الرماية',
  'التزلج على اللوح',
  'التزلج السريع',
  'الاسكواش',
  'الركمجة',
  'السباحة',
  'تنس الطاولة',
  'الرماية',
  'كرة المضرب',
  'كرة طائرة',
  'هوايات المراقبة',
  'داخلياً',
  'مجهرية',
  'قراءة',
  'خارجياً',
  'علم فلك الهواة',
  'جيولوجيا للهواة',
  'علم التنجيم',
  'مراقبة الطيور',
  'كرة القدم الأمريكية الجامعية',
  'هواية العثور على المخابئ',
  'البحث عن الزواحف والبرمائيات',
  'علم الطقس',
  'مراقبة الناس',
  'سفر',
];

final cities = {
  'فلسطين': [
    'القدس',
    'أريحا',
    'الخليل',
    'بيت لحم',
    'جنين',
    'رام الله والبيرة',
    'سلفيت',
    'طوباس',
    'طولكرم',
    'الوزارة/ غزة',
    'قلقيلية',
    'نابلس',
    'دير البلح',
    'خانيونس',
    'رفح',
    'شمال غزة',
    'الداخل',
  ],
  'الأردن': [
    'عمّان',
    'إربد',
    'الزرقاء',
    'السلط',
    'المفرق',
    'الكرك',
    'مادبا',
    'جرش',
    'عجلون	',
    'العقبة',
    'معان',
    'الطفيلة',
  ],
};

final Map<int, Color> maleSwatchList = {
  50: azure1,
  100: azure1,
  200: azure1,
  300: azure1,
  400: azure1,
  500: azure1,
  600: azure1,
  700: azure1,
  800: azure1,
  900: azure1,
};
MaterialColor maleSwatch = MaterialColor(azure1.value, maleSwatchList!);

final Map<int, Color> femaleSwatchList = {
  50: peach1,
  100: peach1,
  200: peach1,
  300: peach1,
  400: peach1,
  500: peach1,
  600: peach1,
  700: peach1,
  800: peach1,
  900: peach1,
};
MaterialColor femaleSwatch = MaterialColor(peach1.value, femaleSwatchList!);

Gradient greyG = LinearGradient(colors: [greyC, greyC]);
Gradient green = LinearGradient(colors: [Colors.green, Colors.greenAccent]);
Color greyC = Colors.grey.shade300;

const prefsGender = "selectedGender";
const prefsLanguage = "selectedLanguage";

Widget UserInfo({Color textColor = Colors.grey,
  String text = '',
  Color iconColor = Colors.grey}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          text,
          maxLines: 3,
          style: TextStyle(color: textColor),
          textDirection: TextDirection.rtl,
        ),
        Icon(
          Icons.info,
          color: iconColor,
        ),
      ],
    ),
  );
}

Widget smallText(text, context, {Color color = Colors.white}) {
  if (color == Colors.white) {}else if(color == Colors.amber){} else {
    color = Theme
        .of(context)
        .primaryColor;
  }
  return Text(
    '$text',
    textDirection: TextDirection.rtl,
    overflow: TextOverflow.visible,
    textAlign: TextAlign.center,
    maxLines: 3,
    style: TextStyle(
        fontSize: screenWidth * 0.035,
        color: color,
        fontWeight: FontWeight.bold),
  );
}

getMessageFromErrorCode(errorCode) {
  switch (errorCode) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "البريد الإلكتروني قد تم استخدامه مسبقاً، الرجاء التوجه لصفحة تسجيل الدخول.";
      break;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "البريد الإلكتروني أو كلمة المرور غير صحيحة.";
      break;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "لا يوجد مستخدم مسجل بهذا البريد الإلكتروني.";
      break;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "حساب المستخدم معطل.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "تم استلام العديد من الطلبات لتسجيل الدخول إلى هذا الحساب.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "خطأ في الخادم، يرجى المحاولة مرة أخرى لاحقاً.";
      break;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "البريد الإلكتروني غير صحيح.";
      break;
    default:
      return "فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.";
      break;
  }
}

Widget bigText(text, context, {Color color = Colors.white}) {
  if (color == Colors.white) {} else {
    color = Theme
        .of(context)
        .primaryColor;
  }
  return Text(
    '$text',
    style: TextStyle(color: color, fontSize: screenWidth * 0.11),
  );
}

Widget gradientText(text, gradient, {Color color = Colors.white}) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) =>
        gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: screenWidth * 0.11),
    ),
  );
}

Widget loadingAnimation() {
  return LoadingAnimationWidget.flickr(
      leftDotColor: peach1, rightDotColor: azure1, size: screenWidth * 0.2);
}

Widget longButton(text, context,
    {Color textColor = Colors.white, buttonColor = Colors.white}) {
  if (buttonColor == Colors.white) {} else
  if (buttonColor == Colors.grey.shade300) {} else {
    buttonColor = Theme
        .of(context)
        .primaryColor;
  }
  return Container(
    padding: EdgeInsets.all(10),
    width: screenWidth * 0.85,
    height: screenWidth * 0.15,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45), color: buttonColor),
    child: FittedBox(
      child: Center(
        child: smallText('$text', context, color: textColor),
      ),
    ),
  );
}

Widget longButtonWithIcon(text, context,
    {Color textColor = Colors.white,
      Color buttonColor = Colors.white,
      Icon icon = const Icon(Icons.question_mark_outlined)}) {
  if (buttonColor != Colors.white || buttonColor != greyC) {
    buttonColor = Theme
        .of(context)
        .primaryColor;
  }
  return Container(
    padding: EdgeInsets.all(10),
    width: screenWidth * 0.85,
    height: screenWidth * 0.15,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45), color: buttonColor),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: icon,
          margin: EdgeInsets.all(5),
        ),
        FittedBox(child: smallText('$text', context, color: textColor)),
      ],
    ),
  );
}

Widget longButtonWithLogo(text,
    Logo logo, {
      Color textColor = Colors.white,
      context,
      Color buttonColor = Colors.white,
    }) {
  if (buttonColor != Colors.white || buttonColor != greyC) {
    buttonColor = Theme
        .of(context)
        .primaryColor;
  }
  return Container(
    padding: EdgeInsets.all(10),
    width: screenWidth * 0.85,
    height: screenWidth * 0.15,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45), color: buttonColor),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        logo,
        FittedBox(child: smallText('$text', context, color: textColor)),
      ],
    ),
  );
}

Widget CustomTextField(controller, hintText, context,
    {TextDirection hintTextDirection = TextDirection.rtl,
      TextDirection textDirection = TextDirection.rtl,
      obsecure = true,
      Function(String)? onChanged,
      borderColor = Colors.white}) {
  borderColor = Theme
      .of(context)
      .primaryColor;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.all(15),
        width: screenWidth * 0.85,
        height: screenWidth * 0.15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            color: Colors.white,
            border: Border.all(color: borderColor)),
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obsecure,
          textDirection: textDirection,
          decoration: InputDecoration.collapsed(
            hintText: '$hintText',
            hintTextDirection: hintTextDirection,
          ),
        ),
      )
    ],
  );
}

void navigateTo(screen, context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void navigateToRep(screen, context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

double screenWidth = ui.window.physicalSize.width / ui.window.devicePixelRatio;
double screenHeight =
    ui.window.physicalSize.height / ui.window.devicePixelRatio;
final Size screenSize = ui.window.physicalSize / ui.window.devicePixelRatio;
final double aspectRatio = screenSize.aspectRatio;
