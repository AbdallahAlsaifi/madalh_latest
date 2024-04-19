import 'package:flutter/material.dart';
import 'package:madalh/controllers/constants.dart' as constants;
class MyBottomSheet extends StatefulWidget {
  final ValueChanged<List<String?>> onSave;

  MyBottomSheet({required this.onSave});

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}
class _MyBottomSheetState extends State<MyBottomSheet> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedArea;

  DropdownButton<String> buildCountryDropdown() {
    return DropdownButton<String>(
      value: _selectedCountry,
      hint: Text('إختر الدولة'),
      items: [
        DropdownMenuItem(
          child: Text('الأردن'),
          value: 'الأردن',
        ),
        DropdownMenuItem(
          child: Text('فلسطين'),
          value: 'فلسطين',
        ),
        DropdownMenuItem(
          child: Text('خارج فلسطين و الأردن'),
          value: 'خارج فلسطين و الأردن',
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCountry = value;
          _selectedCity = null;
          _selectedArea = null;
        });
      },
    );
  }


  DropdownButton<String> buildCityDropdown() {
    List<String> cities = [];

    if (_selectedCountry == 'الأردن') {
      cities = constants.jcities;
    } else if (_selectedCountry == 'فلسطين') {
      cities = constants.pcities;
    }

    return DropdownButton<String>(
      value: _selectedCity,
      hint: Text('إختر المدينة'),
      items: cities.map((city) {
        return DropdownMenuItem(
          child: Text(city),
          value: city,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
          _selectedArea = null;
        });
      },
    );
  }

  DropdownButton<String> buildAreaDropdown() {
    Map<String, List<String>> areas = constants.palestineAreas;

    List<String> areaList = areas[_selectedCity] ?? [];

    return DropdownButton<String>(
      value: _selectedArea,
      hint: Text('إختر المنطقة'),
      items: areaList.map((area) {
        return DropdownMenuItem(
          child: Text(area),
          value: area,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedArea = value;
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCountryDropdown(),
                ],
              ),
              if (_selectedCountry == 'الأردن' ||
                  _selectedCountry == 'فلسطين')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildCityDropdown(),
                  ],
                ),
              if (_selectedCountry == 'فلسطين' && _selectedCity != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildAreaDropdown(),
                  ],
                ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            FilledButton(
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('الغاء'),
            ),FilledButton(
              onPressed: () {
                widget.onSave([_selectedArea, _selectedCity, _selectedCountry]);
                Navigator.pop(context);
              },
              child: Text('حفظ'),
            ),
          ],)
        ],
      ),
    );
  }
}
