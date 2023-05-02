import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class LocationSearch extends StatefulWidget {
  const LocationSearch({Key? key}) : super(key: key);

  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  List<String>? _options;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    ByteData data = await rootBundle.load("asset/location/location.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    var options = <String>[];

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        var option = '${row[0]?.value} ${row[1]?.value} ${row[2]?.value}';

        options.add(option.toString());
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
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _options!.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },

      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}
