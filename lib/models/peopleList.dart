import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/people.dart';

class PeopleList extends CustomizedList<People> {
  // constructor
  PeopleList();

  factory PeopleList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    PeopleList peoples = PeopleList();
    List parseList = parsedJson.map((i) => People.fromJson(i)).toList();
    parseList.forEach((element) {
      peoples.add(element);
    });

    return peoples;
  }

  factory PeopleList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return PeopleList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> peopleMaps = List();
    if (l == null) {
      return null;
    }

    for (People people in l) {
      peopleMaps.add(people.toJson());
    }
    return peopleMaps;
  }

  String toJsonString() {
    List<Map> peopleMaps = List();
    if (l == null) {
      return null;
    }

    for (People people in l) {
      peopleMaps.add(people.toJson());
    }
    return json.encode(peopleMaps);
  }
}
