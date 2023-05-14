import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/constant/home_tabs.dart';

class LocationSearch extends StatefulWidget {
  final onLocationSelected;
  final String? location;

  const LocationSearch({
    Key? key,
    required this.onLocationSelected,
    this.location = '',
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

  // Future<void> _loadOptions() async {
  //   ByteData data = await rootBundle.load("asset/location/location.xlsx");
  //   var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //   var excel = Excel.decodeBytes(bytes);
  //   var options = <String>[];
  //   int cnt = 0;
  //   for (var table in excel.tables.keys) {
  //     for (var row in excel.tables[table]!.rows) {
  //       cnt += 1;
  //       // print(row[2]?.value);
  //       print(cnt);
  //       var option = '';
  //       for (var test in row) {
  //           var str = test!.value.toString();
  //         option = str.toString() + option;
  //       }
  //       print(option);
  // if (row[1] != null && row[2] != null) {
  //   var option = '${row[0]?.value} ${row[1]?.value} ${row[2]?.value}';
  //   options.add(option.toString());
  // } else if (row[1] != null) {
  //   var option = '${row[0]?.value} ${row[1]?.value}';
  //   options.add(option.toString());
  // } else {
  //   var option = '${row[0]?.value}';
  //   options.add(option.toString());
  // }
  //     }
  //   }
  //   setState(() {
  //     _options = options;
  //   });
  // }

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
              _selectedLocation = '';
            },
            child: ImageData(
              IconsPath.findlocation,
              width: 80,
            ),
          ),
        ],
      ),
    );
  }
}
