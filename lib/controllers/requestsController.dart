import 'package:flutter/cupertino.dart';
import 'package:intl_phone_field/phone_number.dart';

class RequestsController with ChangeNotifier{

String conatctRelation = '';
PhoneNumber? phoneNumber;
TextEditingController controller = TextEditingController();

void updateContactRelation(String x){
  conatctRelation = x;
  notifyListeners();
}

void updatePhone(PhoneNumber? ph){
  phoneNumber = ph;
  notifyListeners();
}
void updateTextField(c){
  controller.text = c;
}







}