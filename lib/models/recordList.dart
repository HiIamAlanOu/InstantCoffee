import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/record.dart';

class RecordList extends CustomizedList<Record> {
  // constructor
  RecordList();

  factory RecordList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    RecordList records = RecordList();
    List parseList = parsedJson.map((i) => Record.fromJson(i)).toList();
    parseList.forEach((element) {
      records.add(element);
    });

    return records;
  }

  factory RecordList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return RecordList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> records = new List();
    if (l == null) {
      return null;
    }

    for (Record record in l) {
      records.add(record.toJson());
    }
    return records;
  }

  String toJsonString() {
    List<Map> records = new List();
    if (l == null) {
      return null;
    }

    for (Record record in l) {
      records.add(record.toJson());
    }
    return json.encode(records);
  }
}