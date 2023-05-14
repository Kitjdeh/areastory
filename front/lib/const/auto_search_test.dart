import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:front/constant/home_tabs.dart';

class LocationSearch extends StatefulWidget {
  final onLocationSelected;
  final myLocationSearch;
  final String? location;

  const LocationSearch({
    Key? key,
    required this.onLocationSelected,
    this.location = '',
    required this.myLocationSearch,
  }) : super(key: key);

  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  String? storedLocation;
  String _selectedLocation = '';
  List<String>? _options;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  void _loadOptions() async {
    String jsonData =
        await rootBundle.loadString('asset/location/location.json');
    Map<String, dynamic> jsonDataMap = jsonDecode(jsonData);
    List<Map<String, dynamic>> dataList =
        jsonDataMap['Sheet1'].cast<Map<String, dynamic>>();

    var options = <String>[];

    for (var test in dataList) {
      if (test.length == 1) {
        var option = test["dosi"];
        options.add(option);
      } else if (test.length == 2) {
        var option = test["dosi"] + ' ' + test["sigungu"];
        options.add(option);
      } else {
        var option =
            test["dosi"] + ' ' + test["sigungu"] + ' ' + test["dongeupmyeon"];
        options.add(option);
      }
    }

    setState(() {
      _options = options;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_options == null) {
      return const CircularProgressIndicator();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      constraints: BoxConstraints(maxWidth: 200.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 30,
              child: Autocomplete<String>(
                initialValue: TextEditingValue(
                  text: widget.location!,
                ),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return _options!.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  setState(() {
                    _selectedLocation = selection;
                  });
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_selectedLocation != null) {
                widget.onLocationSelected(_selectedLocation!);
              }
            },
            child: ImageData(
              IconsPath.findlocation,
              width: 80,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () async {
              await widget.myLocationSearch();
            },
            child: ImageData(
              IconsPath.mylocation,
            ),
          ),
        ],
      ),
    );
  }
}
